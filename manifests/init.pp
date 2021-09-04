#
#
#
class profile_base (
  Boolean                   $manage_network,
  Enum['native', 'systemd'] $network_config,
  Boolean                   $disable_ipv6,
  Hash                      $static_routes,
  Hash                      $static_ifaces,
  String                    $domain,
  Array                     $name_servers,
  Array[String]             $default_packages,
  Hash                      $users,
  Hash                      $groups,
  Hash                      $sudo_confs,
  String                    $firewall_ensure,
  Boolean                   $firewall_purge,
  Hash                      $firewall_rules,
  String                    $motd_file,
  Array                     $ntp_servers,
  Boolean                   $manage_firewall_entry,
  Hash                      $mounts,
  String                    $sshd_package_name,
  String                    $sshd_service_name,
  Stdlib::Ip::Address       $ssh_listen_address,
  String                    $ssh_port,
  String                    $ssh_permit_root_login,
  String                    $ssh_password_authentication,
  String                    $ssh_print_motd,
  String                    $ssh_x11_forwarding,
  Boolean                   $manage_puppet,
  Boolean                   $manage_fail2ban,
  String                    $timezone,
  Array                     $fail2ban_services,
  Boolean                   $manage_prometheus_node_exporter,
  Boolean                   $manage_prometheus_process_exporter,
  Boolean                   $manage_prometheus_postfix_exporter,
  Boolean                   $manage_choria,
  Optional[String]          $motd_message,
  Optional[String]          $postfix_relayhost,
  Boolean                   $manage_sd_service                  = lookup('manage_sd_service', Boolean, first, true),
) {
  if $manage_network {
    include profile_base::network
  }
  include profile_base::bash
  include profile_base::repositories
  include profile_base::packages
  include profile_base::accounts
  include profile_base::firewall
  include profile_base::hiera_protection
  include logrotate
  if $manage_prometheus_node_exporter {
    include profile_prometheus::node_exporter
  }
  if $manage_prometheus_process_exporter {
    include profile_prometheus::process_exporter
  }
  include profile_base::motd
  include profile_base::ntp
  if $facts['os']['family'] == 'RedHat' {
    include profile_base::selinux
  }
  if $facts['os']['family'] == 'RedHat' and $facts['is_virtual'] {
    service { 'lm_sensors.service':
      ensure => 'stopped',
      enable => false,
    }
  }
  include profile_base::ssh
  if $manage_puppet {
    include profile_puppet
  }
  include profile_base::systemd
  include profile_base::postfix
  class { 'timezone':
    timezone => $timezone,
  }
  if $manage_fail2ban {
    include profile_base::fail2ban
  }
  if $manage_sd_service {
    include profile_consul
  }
  file { '/etc/profile.d/history.sh':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => 'export HISTTIMEFORMAT="%d/%m/%y %T "'
  }
  if $manage_choria {
    include profile_choria
  }
  if $facts['is_virtual'] {
    package { 'cloud-init':
      ensure => absent,
    }
  }
  create_resources(profile_base::mount, $mounts)
}

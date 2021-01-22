#
#
#
class profile_base (
  Boolean          $manage_network,
  Hash             $static_routes,
  Hash             $static_ifaces,
  String           $domain,
  Array            $name_servers,
  Array[String]    $default_packages,
  Hash             $users,
  Hash             $groups,
  Hash             $sudo_confs,
  String           $firewall_ensure,
  Boolean          $firewall_purge,
  String           $motd_file,
  Array            $ntp_servers,
  Array            $ntp_restrictions,
  Array            $ntp_restrictions_defaults,
  Boolean          $manage_firewall_entry,
  Hash             $mounts,
  String           $sshd_package_name,
  String           $sshd_service_name,
  String           $ssh_port,
  String           $ssh_permit_root_login,
  String           $ssh_password_authentication,
  String           $ssh_print_motd,
  String           $ssh_x11_forwarding,
  Boolean          $manage_puppet,
  Boolean          $puppet_use_srv_records,
  Integer          $puppet_runs_per_hour,
  Boolean          $manage_fail2ban,
  String           $timezone,
  Array            $fail2ban_services,
  Boolean          $manage_sd_service,
  Boolean          $manage_prometheus_node_exporter,
  Boolean          $manage_prometheus_process_exporter,
  Boolean          $manage_prometheus_postfix_exporter,
  Boolean          $manage_choria,
  Optional[String] $motd_message                = undef,
  Optional[String] $puppetmaster                = undef,
  Optional[String] $puppet_srv_domain           = undef,
  Optional[String] $postfix_relayhost           = undef,
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
  include profile_base::ssh
  if $manage_puppet {
    include profile_base::puppet
  }
  include profile_base::systemd
  include profile_base::puppet
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
    content => 'export HISTTIMEFORMAT="%d/%m/%y %t "'
  }
  if $manage_choria {
    include profile_choria
  }
  create_resources(profile_base::mount, $mounts)
}

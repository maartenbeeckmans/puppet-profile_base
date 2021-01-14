#
#
#
class profile_base (
  Boolean          $manage_network,
  String           $interface,
  Boolean          $dhcp,
  String           $netmask,
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
  Boolean          $puppet_use_srv_records,
  Integer          $puppet_runs_per_hour,
  Boolean          $manage_fail2ban,
  String           $timezone,
  Array            $fail2ban_services,
  Boolean          $manage_sd_service,
  Optional[String] $ipaddress                   = undef,
  Optional[String] $gateway                     = undef,
  Optional[String] $motd_message                = undef,
  Optional[String] $puppetmaster                = undef,
  Optional[String] $puppet_srv_domain           = undef,
  Optional[String] $postfix_relayhost           = undef,
) {
  if $manage_network {
    include profile_base::network
  }
  include profile_base::repositories
  include profile_base::packages
  include profile_base::accounts
  include profile_base::firewall
  include logrotate
  include profile_base::monitoring
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
  create_resources(profile_base::mount, $mounts)
}

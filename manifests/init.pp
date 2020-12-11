#
#
#
class profile_base (
  Boolean           $manage_network,
  String            $interface,
  Boolean           $dhcp,
  String            $ipaddress,
  String            $netmask,
  String            $gateway,
  Optional[String]  $domain,
  Array             $name_servers,
  Array             $searchpath,
  Array[String]     $default_packages,
  Hash              $users,
  Hash              $groups,
  Hash              $sudo_confs,
  String            $firewall_ensure,
  Boolean           $firewall_purge,
  Optional[String]  $motd_message,
  String            $motd_file,
  Array             $ntp_servers,
  Array             $ntp_restrictions,
  Array             $ntp_restrictions_defaults,
  Boolean           $manage_firewall_entry,
  String            $sshd_package_name,
  String            $sshd_service_name,
  String            $ssh_port,
  String            $ssh_permit_root_login,
  String            $ssh_password_authentication,
  String            $ssh_print_motd,
  String            $ssh_x11_forwarding,
  Optional[String]  $puppetmaster,
  Boolean           $puppet_use_srv_records,
  Optional[String]  $puppet_srv_domain,
  Integer           $puppet_runs_per_hour,
  Boolean           $manage_fail2ban,
  String            $timezone,
  Array             $fail2ban_services,
  Boolean           $manage_sd_service,
) {
  if $manage_network {
    include profile_base::network
  }
  include profile_base::repositories
  include profile_base::packages
  include profile_base::accounts
  include profile_base::firewall
  include profile_base::monitoring
  include profile_base::motd
  include profile_base::ntp
  include profile_base::ssh
  include profile_base::puppet
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
}

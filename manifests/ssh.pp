#
#
#
class profile_base::ssh (
  String                     $sshd_package_name       = $::profile_base::sshd_package_name,
  String                     $sshd_service_name       = $::profile_base::sshd_service_name,
  Array[Stdlib::Ip::Address] $listen_addresses        = $::profile_base::ssh_listen_addresses,
  String                     $port                    = $::profile_base::ssh_port,
  String                     $permit_root_login       = $::profile_base::ssh_permit_root_login,
  String                     $password_authentication = $::profile_base::ssh_password_authentication,
  String                     $print_motd              = $::profile_base::ssh_print_motd,
  String                     $x11_forwarding          = $::profile_base::ssh_x11_forwarding,
  Boolean                    $manage_firewall_entry   = $::profile_base::manage_firewall_entry,
  Boolean                    $manage_sd_service       = $::profile_base::manage_sd_service,
) {
  package { $sshd_package_name:
    ensure => present,
  }
  resources { 'sshd_config':
    purge => true,
  }
  $listen_addresses.each | Stdlib::IP::Address $listen_address | {
    sshd_config { "Listen address ${listen_address}":
      ensure => present,
      key    => 'ListenAddress',
      value  => $listen_address,
      notify => Service[$sshd_service_name],
    }
  }
  sshd_config { 'Port':
    ensure => present,
    value  => $port,
    notify => Service[$sshd_service_name],
  }
  sshd_config { 'AcceptEnv':
    ensure => present,
    value  => ['LANG', 'LC_*'],
    notify => Service[$sshd_service_name],
  }
  sshd_config { 'ChallengeResponseAuthentication':
    ensure => present,
    value  => 'yes',
    notify => Service[$sshd_service_name],
  }
  sshd_config { 'UsePAM':
    ensure => present,
    value  => 'yes',
    notify => Service[$sshd_service_name],
  }
  sshd_config { 'PermitRootLogin':
    ensure => present,
    value  => $permit_root_login,
    notify => Service[$sshd_service_name],
  }
  sshd_config { 'PasswordAuthentication':
    ensure => present,
    value  => $password_authentication,
    notify => Service[$sshd_service_name],
  }
  sshd_config { 'PrintMotd':
    ensure => present,
    value  => $print_motd,
    notify => Service[$sshd_service_name],
  }
  sshd_config { 'X11Forwarding':
    ensure => present,
    value  => $x11_forwarding,
    notify => Service[$sshd_service_name],
  }
  service { $sshd_service_name:
    ensure => running,
  }
  if $manage_firewall_entry {
  $listen_addresses.each | Stdlib::IP::Address $listen_address | {
    firewall { "000${port} allow ssh ${listen_address}":
      destination => $listen_address,
      dport       => Integer($port),
      action      => 'accept',
    }
  }
  }
  if $manage_sd_service {
    consul::service { 'ssh':
      checks => [
        {
          tcp      => "${facts[networking][ip]}:${port}",
          interval => '10s',
        }
      ],
      port   => Integer($port),
    }
  }
}

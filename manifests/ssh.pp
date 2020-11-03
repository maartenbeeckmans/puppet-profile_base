# == Class: profile_base::ssh
#
# Manages ssh client and server configuration + firewall
#
# === Dependencies
#
# - saz-ssh
#
# === Parameters
#
# $ports                           Array of ssh ports
#
# $permit_root_login               Allow root login with ssh
#
# $password_authentication         Allow password authentication with ssh
#
# $print_motd                      Print motd when connected with ssh
#
# $x11_forwarding                  Allow X11Forwarding with ssh
#
class profile_base::ssh (
  String $sshd_package_name       = 'openssh-server',
  String $sshd_service_name       = 'sshd',
  String $port                    = '22',
  String $permit_root_login       = 'no',
  String $password_authentication = 'yes',
  String $print_motd              = 'no',
  String $x11_forwarding          = 'no',
) {
  package { $sshd_package_name:
    ensure => present,
  }
  resources { 'sshd_config':
    purge => true,
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
    value  => 'no',
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
  firewall { "000${port} allow ssh":
    dport  => Integer($port),
    action => 'accept',
  }
}

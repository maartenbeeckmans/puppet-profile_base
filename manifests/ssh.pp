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
  String    $port                    = '22',
  String    $permit_root_login        = 'no',
  String    $password_authentication  = 'yes',
  String    $print_motd               = 'no',
  String    $x11_forwarding           = 'no',
) {
  resources { 'sshd_config':
    purge => true,
  }
  sshd_config { 'Port':
    ensure => present,
    value  => $port,
  }
  sshd_config { 'PAcceptEnv':
    ensure => present,
    value  => 'LANG LC_*',
  }
  sshd_config { 'ChallengeResponseAuthentication':
    ensure => present,
    value  => 'no',
  }
  sshd_config { 'Subsystem':
    ensure => present,
    value  => 'sftp /usr/lib/openssh/sftp-server',
  }
  sshd_config { 'UsePAM':
    ensure => present,
    value  => 'yes',
  }
  sshd_config { 'PermitRootLogin':
    ensure => present,
    value  => $permit_root_login,
  }
  sshd_config { 'PasswordAuthentication':
    ensure => present,
    value  => $password_authentication,
  }
  sshd_config { 'PrintMotd':
    ensure => present,
    value  => $print_motd,
  }
  sshd_config { 'X11Forwarding':
    ensure => present,
    value  => $x11_forwarding,
  }
  firewall { "000${port} allow ssh":
    dport  => Integer($port),
    action => 'accept',
  }
}

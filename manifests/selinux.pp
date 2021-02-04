#
#
#
class profile_base::selinux {
  file_line { 'disable_selinux':
    ensure => present,
    path   => '/etc/selinux/config',
    line   => 'SELINUX/permissive',
    match  => '^SELINUX=',
  }

  exec { 'disable_selinux':
    user    => 'root',
    command => '/usr/sbin/setenforce permissive',
    unless  => '/usr/sbin/sestatus | /bin/egrep -q "(Current mode:.*permissive|SElinux.*disabled)"',
  }
}

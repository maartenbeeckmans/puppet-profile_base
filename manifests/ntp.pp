#
#
#
class profile_base::ntp (
  Array   $ntp_servers               = $::profile_base::ntp_servers,
) {
  if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '8' {
    class { 'chrony':
      servers => $ntp_servers,
    }
  } else {
    package { 'chrony':
      ensure => absent,
    }

    class { 'ntp':
      servers  => $ntp_servers,
    }
  }
}

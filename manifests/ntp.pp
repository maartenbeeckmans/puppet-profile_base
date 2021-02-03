#
#
#
class profile_base::ntp (
  Array   $ntp_servers               = $::profile_base::ntp_servers,
  Boolean $manage_firewall_entry     = $::profile_base::manage_firewall_entry,
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

  if $manage_firewall_entry {
    firewall{'00123 allow ntp':
      dport  => '123',
      proto  => 'udp',
      action => 'accept',
    }
  }
}

#
#
#
class profile_base::ntp (
  Array   $ntp_servers               = $::profile_base::ntp_servers,
  Array   $ntp_restrictions          = $::profile_base::ntp_restrictions,
  Array   $ntp_restrictions_defaults = $::profile_base::ntp_restrictions_defaults,
  Boolean $manage_firewall_entry     = $::profile_base::manage_firewall_entry,
) {
  package { 'chrony':
    ensure => absent,
  }

  class { 'ntp':
    servers  => $ntp_servers,
    restrict => concat($ntp_restrictions_defaults, $ntp_restrictions)
  }

  if $manage_firewall_entry {
    firewall{'00123 allow ntp':
      dport  => '123',
      proto  => 'udp',
      action => 'accept',
    }
  }
}

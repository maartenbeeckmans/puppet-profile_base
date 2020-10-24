#
#
#
class profile_base::ntp (
  Array   $ntpservers            = [ 'time1.google.com', 'time2.google.com', 'time3.google.com', 'time4.google.com'],
  Array   $restrictions          = [],
  Array   $restrictions_defaults = ['default kod nomodify notrap nopeer noquery', '-6 default kod nomodify notrap nopeer noquery', '127.0.0.1', '-6 ::1'],
  Boolean $open_firewall         = false,
)
{
  package { 'chrony':
    ensure => absent,
  }

  class { 'ntp':
    servers  => $ntpservers,
    restrict => concat($restrictions_defaults, $restrictions)
  }

  if $open_firewall {
    firewall{'00123 allow ntp':
      dport  => '123',
      proto  => 'udp',
      action => 'accept',
    }
  }
}

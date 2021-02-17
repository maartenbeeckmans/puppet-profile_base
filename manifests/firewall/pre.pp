#
#
#
class profile_base::firewall::pre {
  Firewall {
    require => undef,
  }

  # Default rules INPUT CHAIN
  firewall { '00001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }
  firewall { '00002 reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    action      => 'reject',
  }
  firewall { '00003 accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }
  firewall { '05813 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  }
}

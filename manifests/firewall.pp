#
#
#
class profile_base::firewall (
  Enum['iptables','nftables'] $type            = $::profile_base::firewall_type,
  String                      $ensure          = $::profile_base::firewall_ensure,
  Boolean                     $purge           = $::profile_base::firewall_purge,
  Hash                        $firewall_rules  = $::profile_base::firewall_rules,
) {
  if $type == 'iptables' {
    class { 'firewall':
      ensure => $ensure,
    }

    resources { 'firewall':
      purge => $purge,
    }

    create_resources(firewall, $firewall_rules)

    Firewall {
      before  => Class['profile_base::firewall::post'],
      require => Class['profile_base::firewall::pre'],
    }

    class { ['profile_base::firewall::pre', 'profile_base::firewall::post']: }
  } else {
    package { ['iptables', 'iptables-presistent']:
      ensure => 'absent',
    }

    file { ['/etc/sysconfig','/etc/nftables']:
      ensure => directory,
    }
    ~> exec { 'create /etc/sysconfig/nftables.conf':
      path    => $::path,
      command => 'touch /etc/sysconfig/nftables.conf',
      unless  => 'test -e /etc/sysconfig/nftables.conf',
    }
    ~> class { 'nftables':
      inet_filter => false,
      nat         => false,
    }

    class { 'profile_base::firewall::inet_filter': }
  }
}

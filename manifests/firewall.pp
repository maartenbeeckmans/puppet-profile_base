#
#
#
class profile_base::firewall (
  String  $ensure         = $::profile_base::firewall_ensure,
  Boolean $purge          = $::profile_base::firewall_purge,
  Hash    $firewall_rules = $::profile_base::firewall_rules,
) {
  if $facts['os']['family'] == 'RedHat' {
    service { 'firewalld':
      ensure => 'stopped',
      enable => false,
    }
  }

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
}

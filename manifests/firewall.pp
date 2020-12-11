#
#
#
class profile_base::firewall (
  String  $ensure = $::profile_base::firewall_ensure,
  Boolean $purge  = $::profile_base::firewall_purge,
) {
  class { 'firewall':
    ensure => $ensure,
  }

  resources { 'firewall':
    purge => $purge,
  }

  Firewall {
    before  => Class['profile_base::firewall::post'],
    require => Class['profile_base::firewall::pre'],
  }

  class { ['profile_base::firewall::pre', 'profile_base::firewall::post']: }
}

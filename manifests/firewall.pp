# == Class: profile_base::firewall
#
# Manage firewall with Puppet
#
# === Dependencies
#
# - puppetlabs-firewall
#
# === Parameters
#
# $ensure       Controls the state of iptables on the system
#               Must be running or stopped
#
# $entries      A hash of the firewall entries managed by this firewall
#               An entry is an instance of the define profile_base::firewall::entry
#
# $purge        Purge unmanaged firewall rules in this chain
#
class profile_base::firewall (
  String $ensure = 'running',
  Boolean $purge = true,
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

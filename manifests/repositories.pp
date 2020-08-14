# == Class: profile_base::repositories
#
# Manage epel repository
#
# === Dependencies
#
# - puppet-epel
# - puppetlabs-apt
#
# === Parameters
#
# $epel       Manage the epel repository
#
class profile_base::repositories (
  Boolean $epel      = true,
  Boolean $backports = true,
)
{
  if $facts['os']['family'] == 'RedHat' and $epel {
    class { 'epel': }
  }
  if $facts['os']['family'] == 'Debian' {
    class { 'apt': {
      update => {
        frequency => 'daily',
      },
    if $backports {
      class { 'apt::backports':
        pin => 500
      }
    }
  }
}

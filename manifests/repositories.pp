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
)
{
  if $facts['os']['family'] == 'RedHat' and $epel {
    class { 'epel': }
  }
}

# == Class: profile_base::packages
#
# Manage installed base packages on host
#
# === Parameters
#
# $default_packages   Packages to install on the target system
#
class profile_base::packages (
  $default_packages = ['vim-enhanced', 'tree', 'htop', 'bind-utils'],
)
{
  package { $default_packages:
    ensure => present,
  }
}

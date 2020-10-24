# == Class: profile_base::packages
#
# Manage installed base packages on host
#
# === Parameters
#
# $default_packages   Packages to install on the target system
#
class profile_base::packages (
  $default_packages = ['vim', 'tree', 'htop', 'iftop', 'iotop', 'screen', 'telnet', 'silversearcher-ag'],
)
{
  package { $default_packages:
    ensure  => present,
  }
}

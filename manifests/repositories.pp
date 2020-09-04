# == Class: profile_base::repositories
#
# Manage epel repository
#
# === Dependencies
#
# - puppet-epel
# - puppetlabs-apt
#
class profile_base::repositories {
  if $facts['os']['family'] == 'RedHat' {
    class { 'epel': }
  }
}

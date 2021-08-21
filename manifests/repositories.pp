#
#
#
class profile_base::repositories {
  if $facts['os']['family'] == 'RedHat' {
    class { 'epel': }
  }

  if $facts['os']['family'] == 'Debian' {
    include apt
    class { 'apt::backports':
      pin => 100,
    }
  }
}

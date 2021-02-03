#
#
#
class profile_base::repositories {
  if $facts['os']['family'] == 'RedHat' {
    class { 'epel': }
  }

  if $facts['os']['family'] == 'Debian' {
    class { 'apt':
      update      => {
        frequency => 'daily',
      }
    }
    class { 'apt::backports':
      pin => 500,
    }
  }
}

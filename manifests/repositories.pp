#
#
#
class profile_base::repositories {
  if $facts['os']['family'] == 'RedHat' {
    class { 'yum':
      keep_kernel_devel => false,
      clean_old_kernels => false,
      config_options    => {
        metadata_expire => '25m',
        exclude         => 'puppet',
        debuglevel      => 5,
      },
    }

    class { 'epel': }
  }

  if $facts['os']['family'] == 'Debian' {
    include apt
    class { 'apt::backports':
      pin => 100,
    }
  }
}

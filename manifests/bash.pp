#
#
#
class profile_base::bash {
  file { '/etc/profile.d/global_bashrc.sh':
    ensure => present,
    source => 'puppet:///modules/profile_base/profile_global_bashrc.sh',
  }

  file { '/etc/bash.bashrc':
    ensure => present,
    source => 'puppet:///modules/profile_base/global_bash.bashrc',
  }
}

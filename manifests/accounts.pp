#
#
#
class profile_base::accounts (
  Hash $users      = $::profile_base::users,
  Hash $groups     = $::profile_base::groups,
  Hash $sudo_confs = $::profile_base::sudo_confs,
) {
  if length($users) > 0 {
    create_resources( 'accounts::user', $users)
  }

  if length($groups) > 0 {
    create_resources( 'group', $groups)
  }

  if (length($users) > 0) and (length($groups) > 0) {
    Group<||> -> User<||>
  }

  if length($sudo_confs) > 0 {
    class { 'sudo':
      config_file_replace =>  false,
      purge               =>  false,
    }
    create_resources( 'sudo::conf', $sudo_confs)
  }
}

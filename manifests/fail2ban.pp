#
#
#
class profile_base::fail2ban (
  Array $services = $::profile_base::fail2ban_services,
) {
  class { 'fail2ban':
    jails => $services,
  }
}

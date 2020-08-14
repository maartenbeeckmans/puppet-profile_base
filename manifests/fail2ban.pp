# == Class profile_base::fail2ban
#
# Manages fail2ban configuration
#
# === Dependencies
#
# - puppet-fail2ban
#
# === Parameters
#
# $services     Array of services fail2ban manages
#
class profile_base::fail2ban (
  Array $services = ['ssh', 'ssh-ddos']
)
{
  class { 'fail2ban':
    jails => $services,
  }
}

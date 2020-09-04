# == Class: profile_base
#
# This class can be used to setup a bare minimum node
#
# @example when declaring the base class
#  class { '::profile_base': }
#
# === Parameters
#
# $manage_fail2ban      Set to true if puppet must manage fail2ban
#
class profile_base (
  Boolean $manage_fail2ban   = false,
)
{
  contain profile_base::network
  contain profile_base::repositories
  contain profile_base::packages
  contain profile_base::accounts
  contain profile_base::firewall
  contain profile_base::monitoring

  #  class { 'profile_base::network': }
  class { 'profile_base::repositories': }
  -> class { 'profile_base::packages': }
  -> class { 'profile_base::accounts': }
  -> class { 'profile_base::firewall': }
  -> class { 'profile_base::monitoring': }
  -> class { 'profile_base::motd': }
  -> class { 'profile_base::selinux': }
  -> class { 'profile_base::puppet': }
  -> class { 'profile_base::ssh': }

  if $manage_fail2ban {
    class { 'profile_base::fail2ban': }
  }
}

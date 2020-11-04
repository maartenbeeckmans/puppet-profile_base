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
  Boolean $manage_sd_service = false,
)
{
  include profile_base::network
  include profile_base::repositories
  include profile_base::packages
  include profile_base::accounts
  include profile_base::firewall
  include profile_base::monitoring
  include profile_base::motd
  include profile_base::ntp
  include profile_base::ssh
  include profile_base::puppet
  if $manage_fail2ban {
    include profile_base::fail2ban
  }
  if $manage_sd_service {
    include profile_consul
  }
}

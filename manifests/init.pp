# == Class: profile_base
#
# This class can be used to setup a bare minimum node
#
# @example when declaring the base class
#  class { '::profile_base': }
#
# === Parameters
#
# $manage_accounts      Set to true if puppet must manage user accounts,
#                       groups and sudo configurations
#
# $manage_firewall      Set to true if puppet must manage the firewall
#
# $manage_fail2ban      Set to true if puppet must manage fail2ban,
#                       $manage_firewall must be true
#
# $manage_monitoring    Set up monitoring on node
#
# $manage_motd          Set to true if puppet must manage fail2ban
#
# $manage_packages      Set to true if puppet must install basic packages
#
# $manage_puppet        Set to true if puppet must manage puppet_agent
#
# $manage_repos         Set to true if puppet must manage repositories
#
# $manage_network        Set to true if puppet must manage network configuration
#
# $manage_selinux       Set to true if puppet must manage selinux configuration
#
# $manage_ssh           Set to true if puppet must manage ssh configuration
#
class profile_base (
  Boolea $manage_fail2ban   = false,
  Boolean $manage_monitoring = false,
  Boolean $manage_motd       = false,
  Boolean $manage_puppet     = false,
  Boolean $manage_selinux    = false,
  Boolean $manage_ssh        = false,
)
{
  anchor { '::profile_base::begin': }
  -> class { 'profile_base::network': }
  -> class { '::profile_base::repositories' }
  -> class { '::profile_base::packages' }
  -> class { '::profile_base::accounts': }
  -> class { '::profile_base::firewall': }
  -> anchor { '::profile_base::end': }


  if $manage_fail2ban {
    class { 'profile_base::fail2ban': }
  }

  if $manage_monitoring {
    class { 'profile_base::monitoring': }
  }

  if $manage_motd {
    class { 'profile_base::motd': }
  }

  if $manage_puppet {
    class { 'profile::puppet': }
  }

  if $manage_selinux {
    class { 'profile_base::selinux': }
  }

  if $manage_ssh {
    class { 'profile_base::ssh': }
  }
}

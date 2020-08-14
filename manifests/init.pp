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
# $manage_motd          Set to true if puppet must manage fail2ban
#
# $manage_packages      Set to true if puppet must install basic packages
#
# $manage_puppet        Set to true if puppet must manage puppet_agent
#
# $manage_repos         Set to true if puppet must manage repositories
#
# $manage_resolv        Set to true if puppet must manage resolv configuration
#
# $manage_selinux       Set to true if puppet must manage selinux configuration
#
# $manage_ssh           Set to true if puppet must manage ssh configuration
#
class profile_base (
  Boolean $manage_accounts = false,
  Boolean $manage_firewall = false,
  Boolean $manage_fail2ban = false,
  Boolean $manage_motd     = false,
  Boolean $manage_packages = false,
  Boolean $manage_puppet   = false,
  Boolean $manage_repos    = false,
  Boolean $manage_resolv   = false,
  Boolean $manage_selinux  = false,
  Boolean $manage_ssh      = false,
)
{
  if $manage_accounts {
    class { 'profile_base::accounts': }
  }

  if $manage_firewall {
    if $manage_fail2ban {
      class { 'profile_base::fail2ban': }
    }
    class { 'profile_base::firewall': }
  }

  if $manage_motd {
    class { 'profile_base::motd': }
  }

  if $manage_packages {
    class { 'profile_base::packages': }
  }

  if $manage_puppet {
    class { 'profile::puppet': }
  }

  if $manage_repos {
    class { 'profile_base::repositories': }
  }

  if $manage_resolv {
    class { 'profile_base::resolv': }
  }
  if $manage_selinux {
    class { 'profile_base::selinux': }
  }

  if $manage_ssh {
    class { 'profile_base::ssh': }
  }
}

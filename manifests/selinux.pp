# == Class: profile_base::selinux
#
# Manages selinx on the target system
#
# === Dependencies
#
# - puppet-selinux
#
# === Parameters
#
# $mode     The operation state for SELinux
#
# $type     The selinux type
#
class profile_base::selinux (
  String $mode  = 'enforcing',
  String $type  = 'targeted',
)
{
  class { 'selinux':
    mode => $mode,
    type => $type,
  }
}

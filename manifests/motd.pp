# == Class: profile_base::motd
#
# Manages motd on the system
#
# === Dependencies
#
# - puppetlabs-motd
#
# === Parameters
#
# $use_template       Set to true if module uses template defined in profile/base_motd.epp
#
# $motd_message       Set the content of a custom motd when template is not used
#
class profile_base::motd (
  Boolean $use_template = true,
  String  $motd_message = 'This machine is managed by Puppet',
)
{
  if $use_template {
    class {'motd':
      template => 'profile_base/base_motd.epp'
    }
  } else {
    class {'motd':
      content =>  $motd_message,
    }
  }
}

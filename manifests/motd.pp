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
# $motd_message       Set the content of a custom motd
#
class profile_base::motd (
  Optional[String] $motd_message = undef,
  String           $motd_file    = '/etc/motd',
)
{
  concat { $motd_file:
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  file { $motd_file:
    ensure  => present,
    content => epp('profile_base/motd.epp')
  }
  concat::fragment { 'motd_header':
    target => $motd_file,
    source => "${motd_file}.header",
    order  => '05',
  }

  if $motd_message {
    concat::fragment { 'motd_custom_message':
      target  => $motd_file,
      content => $motd_message,
      order   => '10',
    }
  }
}

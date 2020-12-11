#
#
#
class profile_base::motd (
  Optional[String] $motd_message = $::profile_base::motd_message,
  String           $motd_file    = $::profile_base::motd_file,
) {
  concat { $motd_file:
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  file { "${motd_file}.header":
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
      content => "${motd_message}\n",
      order   => '10',
    }
  }
}

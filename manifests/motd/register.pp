#
#
#
define profile_base::motd::register (
  String $content   = undef,
  String $order     = '15',
  String $motd_file = $::profile_base::motd::motd_file,
) {
  if $content {
    $_body = $content
  } else {
    $_body = $name
  }
  concat::fragment { "motd_fragment_${name}":
    target  => $motd_file,
    order   => $order,
    content => "${content}\n",
  }
}

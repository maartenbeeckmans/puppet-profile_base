#
#
#
class profile_base::postfix (
  Optional[String] $relayhost = $::profile_base::postfix_relayhost,
) {
  include postfix

  if $relayhost {
    postfix::config { 'relayhost':
      ensure => present,
      value  => $relayhost,
    }
  }
}

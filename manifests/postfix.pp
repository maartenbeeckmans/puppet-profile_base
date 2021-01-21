#
#
#
class profile_base::postfix (
  Optional[String] $relayhost                          = $::profile_base::postfix_relayhost,
  Boolean          $manage_prometheus_postfix_exporter = $::profile_base::manage_prometheus_postfix_exporter,
) {
  include postfix

  if $relayhost {
    postfix::config { 'relayhost':
      ensure => present,
      value  => $relayhost,
    }
  }

  if $manage_prometheus_postfix_exporter {
    include profile_prometheus::postfix_exporter
  }
}

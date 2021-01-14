#
#
#
class profile_base::systemd (
  Optional[String]  $domain       = $::profile_base::domain,
  Array             $name_servers = $::profile_base::name_servers,
) {
  class { 'systemd':
    manage_resolved   => true,
    resolved_ensure   => 'running',
    dns               => $name_servers,
    domains           => $domain,
    manage_journald   => true,
    journald_settings => {
      'Storage'           => 'persistent',
      'Compress'          => 'yes',
      'SplitMode'         => 'uid',
      'SyncIntervalSec'   => '5m',
      'RateLimitInterval' => '30s',
      'RateLimitBurst'    => '10000',
      'RuntimeMaxUse'     => '32M',
      'MaxFileSec'        => '2week',
    },
  }
}

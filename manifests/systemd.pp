#
#
#
class profile_base::systemd (
  Enum['native', 'systemd'] $network_config = $::profile_base::network_config,
  String                    $domain         = $::profile_base::domain,
  Array                     $name_servers   = $::profile_base::name_servers,
) {
  if $network_config == 'systemd' {
    $_manage_networkd = true
  } else {
    $_manage_networkd = false
  }

  class { 'systemd':
    manage_resolved          => true,
    resolved_ensure          => 'running',
    manage_networkd          => $_manage_networkd,
    manage_all_network_files => true,
    dns                      => $name_servers,
    domains                  => $domain,
    manage_journald          => true,
    journald_settings        => {
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

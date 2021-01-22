#
#
#
class profile_base::puppet (
  Optional[String] $puppetmaster    = $::profile_base::puppetmaster,
  Boolean          $use_srv_records = $::profile_base::puppet_use_srv_records,
  Optional[String] $srv_domain      = $::profile_base::puppet_srv_domain,
  Integer          $runs_per_hour   = $::profile_base::puppet_runs_per_hour,
) {
  # Do not add class to puppetmaster
  unless $facts['networking']['fqdn'] =~ /^puppet\w*/ {
    class { 'puppet':
      agent           => true,
      server          => false,
      show_diff       => true,
      pluginsync      => true,
      puppetmaster    => $puppetmaster,
      use_srv_records => $use_srv_records,
      srv_domain      => $srv_domain,
      runmode         => 'none',
    }
  }
  $_run_interval = 60/$runs_per_hour
  cron { 'puppet-custom-runs':
    command     => '/opt/puppetlabs/bin/puppet agent --test > /dev/null 2>&1',
    user        => root,
    minute      => range(fqdn_rand($_run_interval, $facts['networking']['fqdn']), 59, $_run_interval),
    environment => 'PATH=/bin:/usr/bin:/usr/local/bin',
  }
}

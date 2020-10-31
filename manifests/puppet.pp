#
#
#
class profile_base::puppet (
  Optional[String] $puppetmaster    = undef,
  Boolean          $use_srv_records = false,
  Optional[String] $srv_domain      = undef,
) {
  # Do not add class to puppetmaster
  unless $facts['networking']['fqdn'] =~ /^puppet\w*/ {
    class { 'puppet':
      agent           => true,
      server          => false,
      show_diff       => true,
      puppetmaster    => $puppetmaster,
      use_srv_records => $use_srv_records,
      srv_domain      => $srv_domain,
    }
  }
}

#
#
#
class profile_base::puppet (
  Stdlib::Fqdn $puppetmaster,
) {
  # Do not add class to puppetmaster
  unless $facts['networking']['fqdn'] =~ /^puppet\w*/ {
    class { 'puppet':
      agent        => true,
      server       => false,
      show_diff    => true,
      puppetmaster => $puppetmaster,
    }
  }
}

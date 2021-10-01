#
#
#
class profile_base::hosts (
  Hash $additional_host_entries = $::profile_base::additional_host_entries,
) {
  resources { 'host':
    purge => true,
  }

  Host {
    target       => '/etc/hosts',
    provider     => 'augeas',
  }

  host { 'localhost':
    ensure       => 'present',
    ip           => '127.0.0.1',
    host_aliases => [ 'localhost.localdomain' ],
  }

  host { $facts['networking']['fqdn']:
    ensure       => 'present',
    ip           => '127.0.1.1',
    host_aliases => [ $facts['networking']['hostname'], "${facts['networking']['hostname']}.${::environment}" ],
  }

  create_resources(host, $additional_host_entries, { provider => 'augeas', target => '/etc/hosts' })
}

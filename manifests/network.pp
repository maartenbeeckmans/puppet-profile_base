#
#
#
class profile_base::network (
  String            $interface    = $::profile_base::interface,
  Boolean           $dhcp         = $::profile_base::dhcp,
  String            $ipaddress    = $::profile_base::ipaddress,
  String            $netmask      = $::profile_base::netmask,
  String            $gateway      = $::profile_base::gateway,
  Optional[String]  $domain       = $::profile_base::domain,
  Array             $name_servers = $::profile_base::name_servers,
  Array             $searchpath   = $::profile_base::searchpath,
) {
  if $dhcp {
    network::interface { $interface:
      enable_dhcp => true,
    }
  } elsif $ipaddress {
    network::interface { $interface:
      ipaddress => $ipaddress,
      netmask   => $netmask,
    }
    # Default route
    network::route { $interface:
      ipaddress => ['0.0.0.0'],
      netmask   => ['0.0.0.0'],
      gateway   => [$gateway],
    }
    package { ['isc-dhcp-client', 'isc-dhcp-common']:
      ensure => absent,
    }
  }
  class { 'resolv_conf':
    domainname  => $domain,
    nameservers => $name_servers,
    searchpath  => $searchpath,
  }

  # Disable ipv6
  sysctl { 'net.ipv6.conf.all.disable_ipv6':
    ensure  => present,
    value   => '1',
    comment => 'Disable ipv6',
  }
}

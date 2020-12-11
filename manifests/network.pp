#
#
#
class profile_base::network (
  String            $interface    = 'eth0',
  Boolean           $dhcp         = false,
  String            $ipaddress    = undef,
  String            $netmask      = '255.255.255.0',
  String            $gateway      = undef,
  Optional[String]  $domain       = undef,
  Array             $name_servers = ['8.8.8.8', '8.8.4.4'],
  Array             $searchpath   = [],
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

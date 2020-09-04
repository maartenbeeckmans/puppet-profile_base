# == Class: profile_base::network
#
# Manage the network configuration
#
# === Dependencies
#
# - example42-network
# - saz-resolv_conf
#
# === Parameters
#
# $interface      Name of the interface to configure
#
# $dhcp           Configure DHCP
#
# $ipaddress      Ipadress of the interface
#
# $netmask        Netmask of the interface
#
# $gateway        Default gateway
#
# $domain         The default $::domain
#
# $name_servers   The list of nameservers
#
# $searchpath     List of search domains
class profile_base::network (
  String            $interface    = 'eth0',
  Boolean           $dhcp         = false,
  String            $ipaddress    = undef,
  String            $netmask      = '255.255.255.0',
  String            $gateway      = undef,
  Optional[String]  $domain       = undef,
  Array             $name_servers = ['8.8.8.8', '8.8.4.4'],
  Array             $searchpath   = [],
)
{
  if $dhcp {
    network::interface { $interface:
      enable_dhcp => true,
    }
  } elsif ! $ipaddress {
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
  }
  class { 'resolv_conf':
    domainname  => $domain,
    nameservers => $name_servers,
    searchpath  => $searchpath,
  }
}

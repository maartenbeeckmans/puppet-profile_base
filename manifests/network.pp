#
#
#
class profile_base::network (
  Enum['native', 'systemd'] $network_config = $::profile_base::network_config,
  Boolean                   $disable_ipv6   = $::profile_base::disable_ipv6,
  Hash                      $static_routes  = $::profile_base::static_routes,
  Hash                      $static_ifaces  = $::profile_base::static_ifaces,
) {
  # This loop is looking for network configuration, which is defined by custom facts with the following syntax:
  # cat /etc/facter/facts.d/network.yaml
  # ipaddress_<interface_name>: x.x.x.x
  # netmask_<interface_name>: x.x.x.x
  # gateway_<interface_name>: x.x.x.x
  extend_network_interfaces($::interfaces).each |String $iface| {
    # ipaddress
    $_ipaddress = $facts["init_ipaddress_${iface}"]
    # netmask
    $_netmask = $facts["init_netmask_${iface}"]
    # gateway
    if $facts["init_gateway_${iface}"] == '' {
      $_gateway = undef
    } else {
      $_gateway = $facts["init_gateway_${iface}"]
    }
    # macaddress
    $_primary_iface = regsubst($iface, ':[0-9]*$', '') # eth0.0 > 0
    $_mac_address = $facts["macaddress_${_primary_iface}"]

    if $_ipaddress and $_netmask {
      if $network_config == 'native' {
        network::interface { $iface:
          enable    => true,
          ipaddress => $_ipaddress,
          netmask   => $_netmask,
          hwaddr    => $_mac_address,
          gateway   => $_gateway,
        }
      } else {
        if $facts['os']['family'] == 'Debian' {
          service { 'networking':
            ensure => 'stopped',
            enable => false,
          }

          Systemd::Network <| |> -> Service['networking']
        } else {
          fail('Managing network with systemd-networkd is only supported on debian')
        }
        $_network_config = {
          'interface'   => $iface,
          'mac_address' => $_mac_address,
          'addresses'   => ["${_ipaddress}/${netmask_to_cidr($_netmask)}"],
          'gateway'     => $_gateway,
        }
        systemd::network{"${iface}.network":
          content => epp("${module_name}/systemd_network.epp", $_network_config),
        }
      }
    }
  }

  package { ['isc-dhcp-client', 'isc-dhcp-common']:
    ensure => absent,
  }

  if $disable_ipv6 {
    sysctl { 'net.ipv6.conf.all.disable_ipv6':
      ensure  => present,
      value   => '1',
      comment => 'Disable ipv6',
    }
  } else {
    sysctl { 'net.ipv6.conf.all.disable_ipv6':
      ensure  => present,
      value   => '0',
      comment => 'Enable ipv6',
    }
  }

  if $network_config == 'native' {
    create_resources('::network::route', $static_routes)
    create_resources('::network::if::static', $static_ifaces)
  }
}

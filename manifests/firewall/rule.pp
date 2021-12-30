#
#
#
define profile_base::firewall::rule (
  Enum['iptables','nftables'] $type      = $::profile_base::firewall_type,
  Nftables::SimpleRuleName    $rule_name = $title,
  Pattern[/^\d\d$/]           $order     = '50',
  String                      $chain     = 'input',
  String                      $table     = 'inet-filter',
  Enum['accept', 'continue', 'drop', 'queue', 'return']
                              $action    = 'accept',
  Optional[String]            $comment   = undef,
  Optional[Nftables::Port]    $dport     = undef,
  Optional[Enum['tcp', 'tcp4', 'tcp6', 'udp', 'udp4', 'udp6']]
                              $proto     = 'tcp',
  Optional[Variant[Nftables::Addr, Array[Stdlib::IP::Address]]]
                              $daddr     = undef,
  Enum['ip', 'ip6']           $set_type  = 'ip',
  Optional[Nftables::Port]    $sport     = undef,
  Optional[Variant[Nftables::Addr, Array[Stdlib::IP::Address]]]
                              $saddr     = undef,
  Boolean                     $counter   = false,
) {
  if $type == 'iptables' {
    firewall { "0${order} ${title}":
      action      => $action,
      chain       => upcase($chain),
      destination => $daddr,
      dport       => $dport,
    }

  } else {
    $_set_type = $set_type ? {
      'ip'  => 'ipv4_addr',
      'ip6' => 'ipv6_addr',
    }

    if $daddr =~ Array[Stdlib::IP::Address] {
      nftables::set { "${rule_name}_${set_type}_daddr":
        type     => $_set_type,
        flags    => ['interval'],
        elements => $daddr;
      }
      $_daddr = "@${rule_name}_${set_type}_daddr"
    } else {
      $_daddr = $daddr
    }

    if $saddr =~ Array[Stdlib::IP::Address] {
      nftables::set { "${rule_name}_${set_type}_saddr":
        type     => $_set_type,
        flags    => ['interval'],
        elements => $saddr;
      }
      $_saddr = "@${rule_name}_${set_type}_saddr"
    } else {
      $_saddr = $saddr
    }

    nftables::simplerule { $rule_name:
      comment  => $comment,
      action   => $action,
      order    => $order,
      chain    => $chain,
      table    => $table,
      proto    => $proto,
      set_type => $set_type,
      dport    => $dport,
      daddr    => $_daddr,
      sport    => $sport,
      saddr    => $_saddr,
      counter  => $counter,
    }

  }
}

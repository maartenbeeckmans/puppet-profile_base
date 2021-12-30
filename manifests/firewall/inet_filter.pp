#
#
#
class profile_base::firewall::inet_filter (
  Array[String] $trusted_subnets = $::profile_base::trusted_subnets,
) {
  nftables::config { 'inet-filter': }

  nftables::chain { ['input', 'output', 'forward']: }

  nftables::set { 'trusted_subnets':
      type     => 'ipv4_addr',
      flags    => ['interval'],
      elements => $trusted_subnets;
  }

  nftables::rule {
    'input-type':
      order   => '01',
      content => 'type filter hook input priority 0';
    'input-policy':
      order   => '02',
      content => 'policy drop';
    'input-lo':
      order   => '03',
      content => 'iifname lo accept';
    'input-reject_local_ipv4_traffic_not_on_lo_iface':
      order   => '04',
      content => 'iifname != "lo" ip daddr 127.0.0.0/8 reject';
    'input-reject_local_ipv6_traffic_not_on_lo_iface':
      order   => '04',
      content => 'iifname != "lo" ip6 daddr ::1 reject';
    'input-accept_related_established_drop_invalid':
      order   => '05',
      content => 'ct state vmap { established : accept, related : accept, invalid : drop }';
    'input-icmp':
      content => 'icmp type echo-request limit rate 5/second accept';
    'input-icmpv6':
      content => 'icmpv6 type echo-request limit rate 5/second accept';
    'input-ipv6_neighbour_discovery':
      content => 'icmpv6 type { nd-neighbor-solicit, nd-router-advert, nd-neighbor-advert } accept';

    'output-type':
      order   => '01',
      content => 'type filter hook output priority 0';
    'output-policy':
      order   => '02',
      content => 'policy accept';

    'forward-type':
      order   => '01',
      content => 'type filter hook forward priority 0';
    'forward-policy':
      order   => '02',
      content => 'policy drop';
  }
}

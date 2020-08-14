# == Define: profile_base::firewall::entry
#
# Definition of a firewall entry managed by puppet
#
# === Parameters
#
# $action       The action parameter to perform a match
#               Must be accept, drop or reject
#               - accept: The packet is accepted
#               - drop:   The packet is dropped
#               - reject: The packet is rejected with a suitable ICMP response
#
# $chain        The chain attribute of the resource type firewall 
#               Must be INPUT, FORWARD, OUTPUT, PREROUTING or POSTROUTING
#               The name of the chain to use
#
# $interface    The interface to filer on
#
# $port         The destination port for this filter
#
# $protocol     The specific protocol to match this rule
#               Must be icmp, tcp, sctp, udp or all
#
# $provider     The provider of the firewall chain
#               Must be iptables or ip6tables
#               Default is iptables
#
# $state        Matches a packet based on its state in the firewall statefull inspection state
#               Must be INVALID, ESTABLISHED, NEW, RELATED or UNRELATED
#
define profile_base::firewall::entry (
  Profile::FirewallAction $action = 'accept',
  Profile::FirewallChain $chain = 'INPUT',
  Optional[String] $interface = undef,
  Optional[Variant[Integer, Array[Integer],Array[String]]] $port = undef,
  Profile::FirewallProtocol $protocol = 'tcp',
  Profile::FirewallProvider $provider = 'iptables',
  Optional[Variant[Profile::FirewallState, Array[Profile::FirewallState]]] $state = undef,
) {
  firewall { $name:
    action   => $action,
    chain    => $chain,
    proto    => $protocol,
    provider => $provider,
  }

  if $interface {
    Firewall[$name] {
      iniface => $interface,
    }
  }

  if $port {
    Firewall[$name] {
      dport => $port,
    }
  }

  if $state {
    Firewall[$name] {
      state => $state,
    }
  }
}

# == Class: profile_base::monitoring
#
# This class can be used to set up monitoring
#
# @example when declaring the base class
#  class { '::profile_base::monitoring': }
#
# === Parameters
#
# $prometheus       Install prometheus node exporter on the node
#
class profile_base::monitoring (
  Boolean $prometheus = false,
) {
  if $prometheus {
    include profile_prometheus::node_exporter
  }
}

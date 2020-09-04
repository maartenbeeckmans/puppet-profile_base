# == Class: profile_base::monitoring
#
# This class can be used to set up monitoring
#
# @example when declaring the base class
#  class { '::profile_base::monitoring': }
#
class profile_base::monitoring {
  include profile_prometheus::node_exporter
}

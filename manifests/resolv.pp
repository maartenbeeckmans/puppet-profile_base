# == Class: profile_base::resolv
#
# Manage the resolv configuration
#
# === Dependencies
#
# - saz-resolv_conf
#
# === Parameters
#
# $domain         The default $::domain
#
# $name_servers   The list of nameservers
#
# $searchpath     List of search domains
class profile_base::resolv (
  Optional[String]  $domain       = undef,
  Array             $name_servers = ['127.0.0.1'],
  Array             $searchpath   = [],
)
{
  class { 'resolv_conf':
    domainname  => $domain,
    nameservers => $name_servers,
    searchpath  => $searchpath,
  }
}

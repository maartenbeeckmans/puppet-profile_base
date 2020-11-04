# == Class: profile_base::packages
#
# Manage installed base packages on host
#
# === Parameters
#
# $default_packages   Packages to install on the target system
#
class profile_base::packages (
  $default_packages = ['vim', 'tree', 'curl', 'httpie', 'wget', 'htop', 'iftop', 'iotop', 'tmux', 'telnet', 'silversearcher-ag', 'dnsutils', 'unzip', 'tar'],
)
{
  package { $default_packages:
    ensure  => present,
  }
}

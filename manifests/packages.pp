#
#
#
class profile_base::packages (
  Array[String] $default_packages = $::profile_base::default_packages,
) {
  package { $default_packages:
    ensure  => present,
  }
}

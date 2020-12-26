#
define profile_base::mount (
  String               $device,
  Stdlib::Absolutepath $path    = $name,
  String               $type    = 'ext4',
  Boolean              $mkdir   = true,
  Boolean              $mkfs    = true,
  String               $owner   = 'root',
  String               $group   = 'root',
  Array[String]        $options = ['defaults', 'noatime'],
  String               $dump    = '1',
  String               $pass    = '2',
) {
  if $mkdir {
    file { $path:
      ensure => directory,
      owner  => $owner,
      group  => $group,
      before => Mount[$path]
    }
  }

  if $mkfs {
    filesystem { $device:
      ensure  => present,
      fs_type => $type,
      options => '-F',
    }
  }

  mount { $path:
    ensure  => mounted,
    atboot  => true,
    device  => $device,
    fstype  => $type,
    options => join($options, ','),
    dump    => $dump,
    pass    => $pass,
  }
}

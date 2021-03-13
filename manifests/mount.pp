#
define profile_base::mount (
  Optional[String]     $device     = undef,
  Stdlib::Absolutepath $path       = $name,
  String               $type       = 'ext4',
  Boolean              $mkdir      = true,
  Boolean              $mkfs       = true,
  String               $owner      = 'root',
  String               $group      = 'root',
  String               $mode       = '0644',
  Array[String]        $options    = ['defaults', 'noatime'],
  String               $dump       = '1',
  String               $pass       = '2',
  Optional[String]     $server     = undef,
  Optional[String]     $share      = undef,
  String               $domain     = lookup('profile_nfs::domain', String, first, $facts['networking']['domain']),
  String               $mount_root = lookup('profile_nfs::mount_root', String, first, '/srv'),
) {
  if $mkdir and $type != 'nfs' {
    file { $path:
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => $mode,
      before => Mount[$path]
    }
  }

  if $mkfs and $type != 'nfs' {
    filesystem { $device:
      ensure  => present,
      fs_type => $type,
      options => '-F',
    }
  }

  if $type == 'nfs' {
    include profile_nfs

    nfs::client::mount { $path:
      ensure => mounted,
      server => $server,
      share  => $share,
      owner  => $owner,
      group  => $group,
      atboot => true,
    }
  } else {
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
}

#
define profile_base::mount (
  Optional[String]                      $device              = undef,
  Stdlib::Absolutepath                  $path                = $name,
  Enum['ext4', 'xfs', 'nfs', 'gluster'] $type                = 'xfs',
  Boolean                               $mkdir               = true,
  Boolean                               $mkfs                = true,
  String                                $owner               = 'root',
  String                                $group               = 'root',
  String                                $mode                = '0644',
  Array[String]                         $options             = ['defaults', 'noatime'],
  String                                $dump                = '1',
  String                                $pass                = '2',
  Optional[String]                      $server              = undef,
  Optional[String]                      $share               = undef,
  Optional[Stdlib::Fqdn]                $gluster_server      = undef,
  Optional[String]                      $gluster_volume_name = undef,
  String                                $domain              = lookup('profile_nfs::domain', String, first, $facts['networking']['domain']),
  String                                $mount_root          = lookup('profile_nfs::mount_root', String, first, '/srv'),
) {
  if $mkdir and $type in ['ext4', 'xfs'] {
    file { $path:
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => $mode,
      before => Mount[$path]
    }
  }

  if $mkfs and $type in ['ext4', 'xfs'] {
    filesystem { $device:
      ensure  => present,
      fs_type => $type,
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
  }

  if $type == 'gluster' {
    profile_gluster::mount { $path:
      server      => $gluster_server,
      volume_name => $gluster_volume_name,
    }
  }

  if $type in ['ext4', 'xfs'] {
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

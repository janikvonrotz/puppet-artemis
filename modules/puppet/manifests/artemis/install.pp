# Installs the Artemis package
class puppet::artemis::install (

) inherits puppet::artemis {

  if $clean {

    file { $app_dir:
      ensure  => 'absent',
      recurse => true,
      force   => true,
    }

    file { $data_dir:
      ensure  => 'absent',
      recurse => true,
      force   => true,
    }

    ensure_resource(
      'user',
      $owner,
      {
        'ensure' => 'absent'
      }
    )

    ensure_resource(
      'group',
      $group,
      {
        'ensure' => 'absent'
      }
    )

  } else {

    # create resource only if not declared yet. This allows the same user to be used among multiple puppet modules.
    ensure_resource(
      'group',
      $group,
      {
        'ensure' => 'present',
        gid      => $gid,
      }
    )

    # create resource only if not declared yet. This allows the same group to be used among multiple puppet modules.
    ensure_resource(
      'user',
      $owner,
      {
        'ensure' => 'present',
        uid      => $uid,
        groups   => $membership
      }
    )

    file { $data_dir:
      ensure => 'directory',
      owner  => $owner,
      group  => $group,
      mode   => $folder_write_mode,
    }


    file { 'artemis zip':
      path   => "${tmp_dir}/apache-artemis-${version}-bin.zip",
      source => "puppet:///modules/puppet/artemis/apache-artemis-${version}-bin.zip",
      owner  => $owner,
      group  => $group,
      mode   => $file_read_mode,
    }

    exec { 'unzip artemis zip':
      onlyif  => "test ! -d ${tmp_dir}/apache-artemis-${version}",
      command => "unzip ${tmp_dir}/apache-artemis-${version}-bin.zip -d ${tmp_dir}/",
    }

    file { 'artemis appdir':
      ensure   => directory,
      recurse  => true,
      force    => true,
      path     => $app_dir,
      source   => "${tmp_dir}/apache-artemis-${version}/",
      owner    => $owner,
      group    => $group,
      mode     => $folder_read_mode,
      loglevel => 'debug',
    }
  }
}

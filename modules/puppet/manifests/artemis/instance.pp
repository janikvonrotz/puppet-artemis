# Creates the Artemis instance
class puppet::artemis::instance (

) inherits puppet::artemis {

  if $clean {

    file { $instance_dir:
      ensure  => 'absent',
      recurse => true,
      force   => true,
    }

  } else {

    exec { "create artemis instance ${instance_name}":
      onlyif  => "test ! -d ${instance_dir}",
      command => "${app_dir}/bin/artemis create --host ${host} --default-port ${port} \
      --user ${users[0]['userid']} --password ${users[0]['password']} --require-login ${instance_dir}",
      user    => $owner,
      group   => $group,
    }
  }
}

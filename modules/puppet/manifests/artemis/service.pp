# Sets the state of the Artemis service
class puppet::artemis::service (

) inherits puppet::artemis {

  if $clean {

    service { "artemis ${instance_name}":
      ensure => 'stopped',
      name   => "artemis@${instance_name}",
      enable => false
    }

    file { 'artemis service':
      ensure => 'absent',
      path   => "${service_dir}/artemis@${instance_name}.service",
    }

  } else {

    file { 'artemis service':
      ensure  => file,
      path    => "${service_dir}/artemis@${instance_name}.service",
      owner   => $owner,
      group   => $group,
      mode    => $file_all_read_mode,
      content => epp('puppet/artemis/artemis.service.epp'),
      notify  => Service["artemis ${instance_name}"],
    }

    service { "artemis ${instance_name}":
      ensure => 'running',
      name   => "artemis@${instance_name}",
      enable => true,
    }
  }
}

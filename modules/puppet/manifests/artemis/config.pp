# configures the Artemis instance
class puppet::artemis::config (

) inherits puppet::artemis {

  if $clean {

  } else {

    if ($enable_ssl or $enable_two_way_ssl) {

      exec { "artemis ${instance_name} - remove keystore for ${server_cn} if password changed or is empty":
        onlyif  => "keytool -list -storetype PKCS12 -keystore ${server_keystore} -storepass ${keystore_pass} \
        | grep 'password was incorrect\\|file exists, but is empty'",
        command => "rm ${server_keystore}",
      }

      exec { "artemis ${instance_name} - create pkcs12 keystore for ${server_cn}":
        onlyif  => "keytool -list -keystore ${server_keystore} -storepass ${keystore_pass} \
        | grep $(openssl x509 -noout -fingerprint -sha1 -in ${server_cert} | cut -f2 -d \"=\");test $? -eq 1",
        command => "openssl pkcs12  -export -in ${server_cert} -inkey ${server_key} -passin pass:${server_key_pass} \
           -certfile ${server_ca_cert} -out ${server_keystore} -passout pass:${keystore_pass} -name ${server_cn}",
        notify  => Service["artemis ${instance_name}"],
      }

      file { $server_keystore:
        ensure => file,
        owner  => $owner,
        group  => $group,
        mode   => $file_read_mode,
        notify => Service["artemis ${instance_name}"],
      }

      exec { "artemis ${instance_name} - remove truststore for ${server_cn} if password changed":
        onlyif  => "keytool -list -storetype PKCS12 -keystore ${server_truststore} -storepass ${truststore_pass} \
           | grep 'password was incorrect\\|file exists, but is empty'",
        command => "rm ${server_truststore}",
      }

      exec { "artemis ${instance_name} - create pkcs12 truststore for ${server_cn}":
        onlyif  => "keytool -list -keystore ${server_truststore} -storepass ${truststore_pass} \
           | grep $(openssl x509 -noout -fingerprint -sha1 -in ${server_ca_cert} | cut -f2 -d \"=\");test $? -eq 1",
        command => "keytool -importcert -storetype PKCS12 -keystore ${server_truststore} -storepass ${truststore_pass} \
           -alias ca -file ${server_ca_cert} -noprompt",
        notify  => Service["artemis ${instance_name}"],
      }

      file { $server_truststore:
        ensure => file,
        owner  => $owner,
        group  => $group,
        mode   => $file_read_mode,
        notify => Service["artemis ${instance_name}"],
      }
    }

    file { 'artemis bootstrap configuration':
      ensure  => file,
      path    => "${instance_dir}/etc/bootstrap.xml",
      owner   => $owner,
      group   => $group,
      mode    => $file_read_mode,
      content => epp('puppet/artemis/bootstrap.xml.epp'),
      notify  => Service["artemis ${instance_name}"],
    }

    file { 'artemis broker configuration':
      ensure  => file,
      path    => "${instance_dir}/etc/broker.xml",
      owner   => $owner,
      group   => $group,
      mode    => $file_read_mode,
      content => epp('puppet/artemis/broker.xml.epp'),
      notify  => Service["artemis ${instance_name}"],
    }

    file { "${instance_dir}/etc/jolokia-access.xml":
      ensure => file,
      owner  => $owner,
      group  => $group,
      mode   => $file_read_mode,
      source => 'puppet:///modules/puppet/artemis/jolokia-access.xml',
      notify => Service["artemis ${instance_name}"],
    }
  }
}

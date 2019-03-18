# install and configures Artemis instance
class puppet::artemis (

  String $host = 'localhost',
  Integer $port = 61616,
  Integer $admin_port = 8161,
  String $version = '@ARTEMIS_VERSION@',
  String $instance_name = 'artemis',
  Boolean $clean = ($facts['clean'] or $facts['adnovum_clean']),

  Boolean $is_failover_instance = false,
  Optional[String] $failover_buddy_host = undef,
  String $cluster_user = 'artemis',
  String $cluster_password = 'password',

  Boolean $enable_ssl = false,
  Boolean $enable_two_way_ssl = false, # not implemented

  String $tmp_dir = '/var/tmp',
  String $cert_dir = '/var/tmp/certificates',
  String $service_dir = '/etc/systemd/system',
  String $app_dir = '/opt/artemis',
  String $data_dir = '/var/opt/artemis',
  String $user = 'user',
  String $password = 'password',
  String $instance_dir = "${data_dir}/${instance_name}",

  String $server_ca_cert = "${cert_dir}/ca_cert.pem",

  String $server_cn = $host,
  String $server_cert = "${cert_dir}/${server_cn}_cert.pem",
  String $server_key = "${cert_dir}/${server_cn}_key.pem",
  String $server_key_pass = 'password',

  String $server_keystore = "${cert_dir}/artemis-keystore.pkcs12",
  String $server_truststore = "${cert_dir}/artemis-truststore.pkcs12",
  String $keystore_pass = 'icarke',
  String $truststore_pass = 'icartr',

  String $owner = 'artemis',
  Integer $uid = 30101,
  Array[String] $membership = ['artemis'],
  String $group = 'artemis',
  Integer $gid = 30101,

  String $file_read_mode = 'a=,ug+r',
  String $file_execute_mode = 'a=,ug+rwx',
  String $file_write_mode = 'a=,ug+rx',
  String $file_all_read_mode = 'a=r',

  String $folder_read_mode = 'a=,ug+rx',
  String $folder_write_mode = 'a=,ug+rxw',
  String $folder_all_read_mode = 'a=rx',

) {

  # Component-wide defaulting of the exec path attribute
  Exec {
    path => ['/usr/bin', '/bin']
  }

  if $clean {

    include 'puppet::artemis::service'
    include 'puppet::artemis::config'
    include 'puppet::artemis::instance'
    include 'puppet::artemis::install'

  } else {

    include 'puppet::artemis::install'
    include 'puppet::artemis::instance'
    include 'puppet::artemis::config'
    include 'puppet::artemis::service'

    if $enable_ssl or $enable_two_way_ssl {
      notify { "Open https://${host}:${admin_port}/console in your browser.":}
    } else {
      notify { "Open http://${host}:${admin_port}/console in your browser.":}
    }
  }
}

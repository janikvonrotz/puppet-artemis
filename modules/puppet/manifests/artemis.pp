# @summary Installs and configures an Artemis instance
#
# @example Basic usage
#   class { 'puppet::artemis':
#     instance_name => 'broker',
#     ssl_enabled   => true
#     host          => 'host.example.com',
#     version       => '2.6.4',
#   }
#
# @see https://activemq.apache.org/artemis/docs/latest/index.html
#
# @param [String] host
#   Hostname of the Artemis server.
# @param [Integer] port
#   Port number of the Artemis message interface.
# @param [Integer] admin_port
#   Port number of the Artemis management interface.
# @param [String] version
#   Artemis binary zip version.
# @param [String] instance_name
#   Name of the Artemis instance.
# @param [Boolean] clean
#   If set the cleanup instead of the install tasks will be executed.
# @param [Boolean] is_failover_instance
#   Defines wether this intance is a failover instance in a cluster setup.
# @param [Optional[String]] failover_buddy_host
#   Sets the failover buddy host in a cluster setup.
# @param [String] cluster_user
#   Username for cluster access.
# @param [String] cluster_password
#   Password for cluster access.
# @param [Boolean] enable_ssl
#   Enable ssl for the management and message interface.
# @param [Boolean] enable_two_way_ssl
#   Enable two-way-ssl for the management and message interface.
# @param [String] user
#   Username for management and message interface access.
# @param [String] password
#   Password for management and message interface access.
# @param [String] tmp_dir
#   Temporary folder where Artemis binary zip is unpacked.
# @param [String] cert_dir
#   Folder containing the x509 PEM cerificates for assembling the keystores.
# @param [String] service_dir
#   Target systemd service folder.
# @param [String] app_dir
#   Application directory where Artemis binaries are installed.
# @param [String] data_dir
#   Data directory where Artemis instances are created.
# @param [String] instance_dir
#   Directory where artemis instance files are stored.
# @param [String] server_ca_cert
#   Path to the server CA certificate file.
# @param [String] server_cn
#   Server certificate common name.
# @param [String] server_cert
#   Path to the server certificate file.
# @param [String] server_key
#   Path to the server certificate key file.
# @param [String] server_key_pass
#   Password of the server certificate key file.
# @param [String] server_keystore
#   Path to the server keystore file.
# @param [String] server_truststore
#   Path to the server truststore file.
# @param [String] keystore_pass
#   Password of the server keystore file.
# @param [String] truststore_pass
#   Password of the server truststore file.
# @param [String] owner
#   Artemis service username.
# @param [Integer] uid
#   User ID of the Artemis service user.
# @param [Array[String]] membership
#   List of group names of which the Artemis service user is a member.
# @param [String] group
#   Artemis service group name.
# @param [Integer] gid
#   Group ID of the Artemis service group.
# @param [String] file_read_mode
#   Default file read mode mask.
# @param [String] file_execute_mode
#   Default file execute mode mask.
# @param [String] file_write_mode
#   Default file write mode mask.
# @param [String] file_all_read_mode
#   Default file read mode mask for all users.
# @param [String] folder_read_mode
#   Default folder read mode mask.
# @param [String] folder_write_mode
#   Default folder write mode mask.
# @param [String] folder_all_read_mode
#   Default folder read mode mask for all users.
#
class puppet::artemis (

  String $host = 'localhost',
  Integer $port = 61616,
  Integer $admin_port = 8161,
  String $version = '@ARTEMIS_VERSION@',
  String $instance_name = 'artemis',
  Boolean $clean = $facts['clean'],
  Boolean $is_failover_instance = false,
  Optional[String] $failover_buddy_host = undef,
  String $cluster_user = 'artemis',
  String $cluster_password = 'password',
  Boolean $enable_ssl = false,
  Boolean $enable_two_way_ssl = false,
  String $user = 'user',
  String $password = 'password',
  String $tmp_dir = '/var/tmp',
  String $cert_dir = '/var/tmp/certificates',
  String $service_dir = '/etc/systemd/system',
  String $app_dir = '/opt/artemis',
  String $data_dir = '/var/opt/artemis',
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

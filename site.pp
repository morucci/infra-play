#
# Top-level variables
#
# There must not be any whitespace between this comment and the variables or
# in between any two variables in order for them to be correctly parsed and
# passed around in test.sh
#

#
# Default: should at least behave like an openstack server
#
node default {
  class { 'openstack_project::server':
    sysadmins => hiera('sysadmins', []),
  }
}

node 'mysql.test.localdomain' {
  class { 'mysql::server':
    config_hash => {
        'root_password' => hiera('mysql_root_password', 'XXX'),
        'bind_address' => '0.0.0.0',
    },
  }
  mysql::db { 'reviewdb':
    user     => 'gerrit2',
    password => hiera('mysql_gerrit_password', 'XXX'),
    host     => 'gerrit.test.localdomain',
    grant    => ['all'],
  }
}

node 'jenkins.test.localdomain' {
  class { 'openstack_project::jenkins':
    project_config_repo     => 'https://github.com/morucci/project-config.git',
    jenkins_jobs_password   => hiera('jenkins_jobs_password', 'XXX'),
    jenkins_ssh_private_key => hiera('fake_rsa_ssh_private_key_contents', 'XXX'),
    ssl_cert_file_contents  => hiera('fake_ssl_cert_file_contents', 'XXX'),
    ssl_key_file_contents   => hiera('fake_ssl_key_file_contents', 'XXX'),
    ssl_chain_file_contents => hiera('fake_ssl_chain_file_contents', 'XXX'),
    sysadmins               => hiera('sysadmins', []),
    zmq_event_receivers     => [],
  }
}

node 'zuul.test.localdomain' {
  class { 'openstack_project::zuul_prod':
    project_config_repo           => 'https://github.com/morucci/project-config.git',
    gerrit_server                 => 'gerrit.test.localdomain',
    gerrit_user                   => 'jenkins',
    gerrit_ssh_host_key           => hiera('fake_rsa_ssh_public_key_contents', 'XXX'),
    zuul_ssh_private_key          => hiera('fake_rsa_ssh_private_key_contents', 'XXX'),
    status_url                    => 'http://status.test.localdomain/zuul/',
    proxy_ssl_cert_file_contents  => hiera('fake_ssl_cert_file_contents', 'XXX'),
    proxy_ssl_key_file_contents   => hiera('fake_ssl_key_file_contents', 'XXX'),
    proxy_ssl_chain_file_contents => hiera('fake_ssl_chain_file_contents', 'XXX'),
    zuul_url                      => 'http://zuul.test.localdomain/p',
    gearman_workers               => ['jenkins.test.localdomain'],
    gerrit_ident                  => "gerrit.test.localdomain",
  }
}

node 'zm.test.localdomain' {
  class { 'openstack_project::zuul_merger':
    gearman_server       => 'zuul.test.localdomain',
    gerrit_server        => 'gerrit.test.localdomain',
    gerrit_user          => 'jenkins',
    gerrit_ssh_host_key  => hiera('fake_rsa_ssh_public_key_contents', 'XXX'),
    zuul_ssh_private_key => hiera('fake_rsa_ssh_private_key_contents', 'XXX'),
    sysadmins            => hiera('sysadmins', []),
  }
}

node 'gerrit.test.localdomain' {
  class { 'openstack_project::gerrit':
      mysql_host                          => "mysql.test.localdomain",
      mysql_password                      => hiera('mysql_gerrit_password', 'XXX'),
      serveradmin                         => 'toto@gerrit.test.localdomain',
      ssl_cert_file_contents              => hiera('fake_ssl_cert_file_contents', 'XXX'),
      ssl_key_file_contents               => hiera('fake_ssl_key_file_contents', 'XXX'),
      ssl_chain_file_contents             => hiera('fake_ssl_chain_file_contents', 'XXX'),
      ssh_dsa_key_contents                => hiera('fake_dsa_ssh_private_key_contents', 'XXX'),
      ssh_dsa_pubkey_contents             => hiera('fake_dsa_ssh_public_key_contents', 'XXX'),
      ssh_rsa_key_contents                => hiera('fake_rsa_ssh_private_key_contents', 'XXX'),
      ssh_rsa_pubkey_contents             => hiera('fake_rsa_ssh_public_key_contents', 'XXX'),
      ssh_project_rsa_key_contents        => hiera('fake_rsa_ssh_private_key_contents', 'XXX'),
      ssh_project_rsa_pubkey_contents     => hiera('fake_rsa_ssh_public_key_contents', 'XXX'),
      ssh_welcome_rsa_key_contents        => hiera('fake_rsa_ssh_private_key_contents', 'XXX'),
      ssh_welcome_rsa_pubkey_contents     => hiera('fake_rsa_ssh_public_key_contents', 'XXX'),
      ssh_replication_rsa_key_contents    => hiera('fake_rsa_ssh_private_key_contents', 'XXX'),
      ssh_replication_rsa_pubkey_contents => hiera('fake_rsa_ssh_public_key_contents', 'XXX'),
      email                               => 'toto@gerrit.test.localdomain',
      war                                 => 'http://tarballs.openstack.org/ci/test/gerrit-v2.8.4.19.7c824ff.war',
      replicate_local                     => false,
      testmode                            => true,
  }
}
# vim:sw=2:ts=2:expandtab:textwidth=79

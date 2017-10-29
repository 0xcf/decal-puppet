# Broken Apache installation for Processes and Services lecture.
# Configuration files contain misspellings
# Also /srv/www has the wrong permissions set
class decal_common::broken_apache {
  package { 'apache2':; } ->
  file {
    # This file, installed by Apache, masks the nginx landing page, so we
    # remove it.
    '/var/www/html/index.html':
      ensure => absent;
  } ->
  file {
    '/opt/lab6':
      source  => 'puppet:///modules/decal_common/lab6',
      recurse => true;

    '/opt/lab6/setup.sh':
      source  => 'puppet:///modules/decal_common/lab6/setup.sh',
      mode    => '0755',
  } ~>
  exec {
    '/opt/lab6/setup.sh':
      refreshonly => true,
  }
}

class decal_common::bind {
  package { ['bind9', 'dnsutils']:; }

  # This is the best way I could find to replace a default file but still let
  # decal users edit it as they want
  exec { 'check_named_options':
    command => '/bin/cp /opt/lab7/named.conf.options /etc/bind/named.conf.options',
    onlyif  => '/bin/grep -q "If there is a firewall between" /etc/bind/named.conf.options',
    require => File['/opt/lab7/named.conf.options'],
  }

  file {
    '/opt/lab7/named.conf.options':
      ensure  => present,
      source  => 'puppet:///modules/decal_common/lab7/named.conf.options',

      # TODO: Make this dependency better, maybe make the directory using file
      # instead of exec and then make each subdirectory with exec to avoid
      # managing permissions on the NFS mount points?
      require => Exec['/bin/mkdir -p /opt/lab7/read-only'];

    '/opt/lab7/db.example.com':
      ensure  => present,
      content => template('decal_common/db.example.com.erb');
  }
}

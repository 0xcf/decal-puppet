class decal_student::labs::lab7 {
  # Create directories to mount NFS shares on
  # Directory permissions are set by NFS share when mounted
  # Use exec instead of file so that permissions are not managed
  exec {
    '/bin/mkdir -p /opt/lab7/read-only':
      creates => '/opt/lab7/read-only';
    '/bin/mkdir -p /opt/lab7/read-write':
      creates => '/opt/lab7/read-write';
  }

  # Install dnsutils for the dig command
  package { 'dnsutils':; }

  # This is the best way I could find to replace a default file but still let
  # decal users edit it as they want
  exec { 'check_named_options':
    command => '/bin/cp /opt/lab7/named.conf.options /etc/bind/named.conf.options',
    onlyif  => '/bin/grep -q "If there is a firewall between" /etc/bind/named.conf.options',
    require => File['/opt/lab7/named.conf.options'],
  }

  file {
    '/opt/lab7':
      ensure => directory;

    '/opt/lab7/named.conf.options':
      ensure  => present,
      source  => 'puppet:///modules/decal_student/named.conf.options',
      require => File['/opt/lab7'];

    '/opt/lab7/db.example.com':
      ensure  => present,
      content => template('decal_student/db.example.com.erb');
  }
}

class decal_common::timezone {
  # Set the system time to Pacific time
  file { '/etc/localtime':
    ensure => 'link',
    target => '/usr/share/zoneinfo/America/Los_Angeles',
  }

  exec { 'dpkg-reconfigure tzdata':
    command     => '/usr/sbin/dpkg-reconfigure -f noninteractive tzdata',
    subscribe   => File['/etc/localtime'],
    refreshonly => true,
  }
}

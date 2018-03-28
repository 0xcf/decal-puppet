class decal_staff::puppetmaster {
  package { 'puppet-master-passenger':; }

  service { 'apache2':
    ensure => 'running',
  }

  file { '/etc/puppet/hiera.yaml':
    source => 'puppet:///modules/decal_staff/hiera.yaml',
    notify => Service['apache2'],
  }

  file { '/etc/puppet/private.yaml':
    owner  => puppet,
    group  => puppet,
    mode   => '0600',
    notify => Service['apache2'],
  }
}

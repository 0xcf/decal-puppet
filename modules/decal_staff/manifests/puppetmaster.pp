class decal_staff::puppetmaster {
  package { 'puppet-master-passenger':; }

  service { 'apache2':
    ensure => 'running',
  }

  file { '/etc/puppet/hiera.yaml':
    source => 'puppet:///modules/decal_staff/hiera.yaml',
    notify => Service['apache2'],
  }
}

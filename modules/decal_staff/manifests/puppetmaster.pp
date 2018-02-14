class decal_staff::puppetmaster {
  package { 'puppet-master-passenger':; }

  service { 'apache2':
    ensure => 'running',
  }
}

class decal_puppet {
  package { 'puppet-master-passenger':; }

  service { 'apache2':
    ensure => 'running',
  }
}

class decal_common {
  include decal_common::vim

  package { ['tree', 'augeas-tools']:; }

  file {
    '/etc/hostname':
      content => "$::hostname";

    '/etc/motd':
      content => template('decal_common/motd.erb'),
  }

  # Run puppet as a cron job every 10 minutes
  cron { 'puppet-agent':
    ensure      => present,
    command     => 'puppet agent -t',
    user        => 'root',
    minute      => [fqdn_rand(10), fqdn_rand(10) + 10, fqdn_rand(10) + 20, fqdn_rand(10) + 30, fqdn_rand(10) + 40, fqdn_rand(10) + 50],
  }
}

class decal_common {
  include decal_common::bind
  include decal_common::broken_apache
  include decal_common::nfs
  include decal_common::timezone
  include decal_common::vim

  $owner = lookup('owner', { 'default_value' => undef, });

  package {
    ['augeas-tools',
     'fail2ban',
     'htop',
     'iotop',
     'tree',
     'virtualenv',
     'git']:;
  }

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

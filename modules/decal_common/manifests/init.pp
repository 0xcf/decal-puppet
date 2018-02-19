class decal_common {
  include decal_common::timezone
  include decal_common::vim

  $owner = lookup('owner', { 'default_value' => undef, });

  package {
    ['augeas-tools',
     'fail2ban',
     'htop',
     'iotop',
     'resolvconf',
     'tree',
     'virtualenv',
     'git',
     'emacs',
     'tmux']:;
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

  # Don't run puppet as a service since it is being run as a cron job
  service { 'puppet':
    ensure => stopped,
    enable => false,
  }

  # Set up networking to allow puppet to find the puppet master
  #
  # Note: configuring this with puppet doesn't make much sense since puppet
  # can't run if this doesn't work already, but at least for anyone reading
  # this it will make it clearer what needs to be done to get puppet working.
  file { '/etc/resolvconf/resolv.conf.d/base'
    content => "domain decal.xcf.sh\n",
  }
}

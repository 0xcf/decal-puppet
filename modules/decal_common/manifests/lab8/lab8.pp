class decal_common::lab8::lab8 {

  $owner = lookup('owner')

  package { 
  	[
         # gpg key generation requires a lot of entropy which isn't available 
         # on VMs because /dev/urandom isn't backed by a hardware RNG
     	'haveged',
    	]:;

      /*
        'certbot', # we trust students will know how to install these packages for themselves
        'nginx',
        'gnupg',
        'openssl',
      */
  }

  # we don't want to cache the passwords so students will
  # be forced to type them in 
  package { 'gpg-agent':
  	ensure => absent;
  }

  user { 'lab8user':
    comment => 'Account for students to test against',
    home    => '/opt/lab8/lab8user/',
    shell   => '/bin/bash',
    system  => true,
  }

  file {
    [
      '/var/www/html/.well_known',
      '/opt/lab8',
    ]:
      ensure => directory;

    '/etc/nginx/sites-available/default-lab8':
      source => 'puppet:///modules/decal_common/lab8/nginx-lab8.conf';

    '/etc/nginx/snippets/ssl-params.conf':
      source => 'puppet:///modules/decal_common/lab8/ssl-params.conf';

    '/opt/lab8/lab8user':
      ensure => directory,
      mode   => '0755',
      owner  => lab8user,
      group  => lab8user,
      require => User['lab8user'];

    # make file readable and answer question using chmod
    # sudo chmod o+r file1.txt, 1991
    '/opt/lab8/file1.txt':
      content => "year linux was first released?",
      group   => admin,
      mode    => '0600';

    # set file owner to user:user and perms to 600
    # sudo chown user:user file2.txt
    # sudo chmod 600 file2.txt
    '/opt/lab8/file2.txt':
      content => "important decal secrets",
      owner   => root,
      group   => $owner,
      mode    => '0007';

    # change ownership to root and restrict all access except user read
    # sudo chown root:root file3.txt
    # sudo chmod 400 file3.txt
    '/opt/lab8/file3.txt':
      content => "super secret decal secrets",
      owner => $owner,
      group => $owner,
      mode  => '0777';

    [
     '/opt/lab8/file4.txt', 
     '/opt/lab8/file5.txt', 
    ]:
      owner => lab8user, # make readable to us by any means necessary
      group => lab8user, # make unreadable to lab8user
      mode  => '0700',
      require => User['lab8user'],
      ensure => present;

    '/opt/lab8/file6.txt': # explain the following permissions
      mode => '0147',  # u+x, g+r, o+rwx
      ensure => present;

    '/opt/lab8/file7.txt':
      mode => '0562',  # u+rx, g+rw, o+w
      ensure => present;

    [      
     '/opt/lab8/file8.txt', # provide a strategy to make these files readable to lab8user and yourself and no one else
     '/opt/lab8/file9.txt', # e.g. add lab8 user to your group and do chown :username + chmod 040 
    ]:
      mode => '0000',
      ensure => present;
  }
}

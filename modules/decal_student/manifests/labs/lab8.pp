class decal_student::labs::lab8 {

  package {
        [
          # needed for entropy generation on VMs
          'haveged',
        ]:;
  }

  package { 'gpg-agent':
    # remove gpg-agent so they have to type the passwords every time
    ensure => absent;
  }

  user { 'a8user':
    comment => 'Account for students to test against',
    home    => '/opt/a8/',
    shell   => '/bin/bash',
    system  => true,
  }

  file {
    [
      '/var/www/html/.well_known',
      '/etc/nginx/',
      '/etc/nginx/snippets/',
      '/etc/nginx/sites-enabled/'
    ]:
      ensure => directory;

    '/etc/nginx/sites-enabled/default-a8.conf':
      source => 'puppet:///modules/decal_student/a8/nginx-a8.conf';

    '/etc/nginx/snippets/ssl-params.conf':
      source => 'puppet:///modules/decal_student/a8/ssl-params.conf';

    '/opt/a8/':
      ensure  => directory,
      mode    => '0755',
      owner   => a8user,
      group   => a8user,
      require => User['a8user'];

    # make file readable and answer question using chmod
    # sudo chmod o+r file1.txt, 1991
    '/opt/a8/file1.txt':
      content => "year linux was first released?",
      group   => root,
      mode    => '0600';

    # set file owner to user:user and perms to 600
    # sudo chown user:user file2.txt
    # sudo chmod 600 file2.txt
    '/opt/a8/file2.txt':
      content => "important decal secrets",
      owner   => root,
      group   => $::hostname,
      mode    => '0007';

    # change ownership to root and restrict all access except user read
    # sudo chown root:root file3.txt
    # sudo chmod 400 file3.txt
    '/opt/a8/file3.txt':
      content => "super secret decal secrets",
      owner => $::hostname,
      group => $::hostname,
      mode  => '0777';

    [
      '/opt/a8/file4.txt',
      '/opt/a8/file5.txt',
    ]:
      owner => a8user, # make readable to us by any means necessary
      group => a8user, # make unreadable to a8user
      mode  => '0700',
      require => User['a8user'],
      ensure => present;

    '/opt/a8/file6.txt': # explain the following permissions
      mode => '0147',  # u+x, g+r, o+rwx
      ensure => present;

    '/opt/a8/file7.txt':
      mode => '0562',  # u+rx, g+rw, o+w
      ensure => present;

    [
      '/opt/a8/file8.txt', # provide a strategy to make these files readable to a8user and yourself and no one else
      '/opt/a8/file9.txt', # e.g. add lab8 user to your group and do chown :username + chmod 040
    ]:
      mode => '0000',
      ensure => present;
  }
}


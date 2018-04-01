class decal_staff::nfs {
  package { 'nfs-kernel-server':; }

  service { 'nfs-server':
    ensure => 'running',
  }

  $beginner_decal_users = lookup('beginner_decal_users', Array)
  $advanced_decal_users = lookup('advanced_decal_users', Array)
  $decal_usernames = $beginner_decal_users + $advanced_decal_users
  $secret_word = lookup('lab7_secret_word', String)

  file { '/etc/exports':
    content => template('decal_staff/exports.erb'),
  }

  file { ['/opt/lab7', '/opt/lab7/public']:
    ensure => directory,
  }

  file { '/opt/lab7/public/secret.txt':
    ensure  => present,
    content => "The secret word is '${secret_word}', this goes in the lab checkoff form.\n",
  }

  $decal_usernames.each |String $user| {
    exec { "/bin/mkdir -p /opt/lab7/private/${user}":
      creates => "/opt/lab7/private/${user}";
    }

    file { "/opt/lab7/private/${user}/README.txt":
      ensure  => present,
      replace => 'no',
      content => template('decal_staff/default_NFS_README.txt.erb'),
      require => Exec["/bin/mkdir -p /opt/lab7/private/${user}"],
    }
  }
}

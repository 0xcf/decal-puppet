class decal_nfs {
  package { 'nfs-kernel-server':; }
  service { 'nfs-server':; }

  # Decal usernames
  # TODO: This is a pretty bad place to put this list, it should probably be in
  # hiera or something?
  $decal_usernames = [
    'aaxu',
    'ahmedali',
    'andrewcullen',
    'arshiagg',
    'benwu',
    'christam',
    'csungwon',
    'dfang',
    'donalds',
    'dzhli',
    'giridhn',
    'hdharam',
    'hongseokjang',
    'jani',
    'jasonjkim',
    'jasonlum',
    'jeigenbrood',
    'jhshi',
    'jkgurung',
    'khepler',
    'lxing',
    'ntalcus',
    'rpthornton',
    'ruoyu',
    'sjamil',
    'starrtyang',
    'sttian',
    'takemori',
    'tanx',
    'tmjchu',
    'trliu',
    'truongpham',
    'vaibhavj',
    'villagomezd',
    'yena',
  ]

  file { '/etc/exports':
    content => template('decal_nfs/exports.erb'),
  }

  $decal_usernames.each |String $user| {
    exec { "/bin/mkdir /opt/lab7/private/${user}":
      creates => "/opt/lab7/private/${user}";
    }

    file { "/opt/lab7/private/${user}/README.txt":
      ensure  => present,
      replace => 'no',
      content => template('decal_nfs/default_README.txt.erb'),
    }
  }
}

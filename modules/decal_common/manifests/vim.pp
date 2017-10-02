class decal_common::vim {
  package { ['vim']:; }

  file { '/etc/vim/vimrc.local':
    source  => 'puppet:///modules/decal_common/vimrc.local',
    require => Package['vim'],
  }
}

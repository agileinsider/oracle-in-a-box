class oracle::installer {
  include oracle::params
  include oracle::user
  include oracle::cleanup
  
  Exec { path => ['/usr/local/sbin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/bin', '/bin'] }

  file {'/app/oracle/install':
    owner => 'oracle',
    group => 'oinstall',
    mode => 0770,
    ensure => directory,
    require => [ File['/app/oracle'], User['oracle'] ]
  } 
  
  exec {'unzip_installer':
    command => 'unzip -o /tmp/downloads/linux.x64_11gR2_database_1of2.zip -d /app/oracle/install; unzip -o /tmp/downloads/linux.x64_11gR2_database_2of2.zip -d /app/oracle/install',
    cwd => '/tmp/downloads',
    user => 'oracle',
    group => 'oinstall',
    creates => '/app/oracle/install/database',
    provider => 'shell',
    require => File['/app/oracle/install']
  }
  
  file {'/app/oracle/install/db_install.rsp':
    owner => 'oracle',
    group => 'oinstall',
    mode => 0640,
    source => 'puppet:///modules/oracle/db_install.rsp',
    require => File['/app/oracle/install']
  }
  
  exec {'install_oracle':
    command => '/app/oracle/install/database/runInstaller -silent -ignoreSysPrereqs -ignorePrereq -noconfig -waitforcompletion -responseFile /app/oracle/install/db_install.rsp',
    cwd => '/app/oracle/install/database',
    user => 'oracle',
    group => 'oinstall',
    creates => '/app/oracle/local/product/11.2.0.1.0/db_in_box/root.sh',
    provider => 'shell',
    require => [ File['/app/oracle/install/db_install.rsp'], Exec['unzip_installer'] ]
  }
  
  exec {'post_install_root':
    command => '/app/oracle/local/product/11.2.0.1.0/db_in_box/root.sh',
    user => 'root',
    group => 'root',
    provider => 'shell',
    require => Exec['install_oracle']
  }
  
  exec {"post_install_cleanup":
    command => 'rm -Rf /app/oracle/install/database/*',
    user => 'root',
    group => 'root',
    provider => 'shell',
    require => Exec['install_oracle'],
    notify => Exec['zero_disk']
  }
}
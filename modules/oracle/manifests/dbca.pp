class oracle::dbca {
  include oracle::user
  include oracle::installer
  include oracle::listener
  include oracle::cleanup
  
  Exec { path => ['/usr/local/sbin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/bin', '/bin', '/app/oracle/local/product/11.2.0.1.0/db_in_box/bin'] }
  
  file {'/app/oracle/install/dbca.rsp':
    owner => 'oracle',
    group => 'oinstall',
    mode => 0640,
    source => 'puppet:///modules/oracle/dbca.rsp',
    require => File['/app/oracle/install']
  }
  
  exec {'create_database':
    command => '/app/oracle/local/product/11.2.0.1.0/db_in_box/bin/dbca  -silent -responseFile /app/oracle/install/dbca.rsp; touch /app/oracle/install/dbca.complete',
    cwd => '/app/oracle/install',
    user => 'oracle',
    group => 'oinstall',
    creates => '/app/oracle/local/admin/oracle/pfile',
    provider => 'shell',
    timeout => 1200,
    require => [ File['/app/oracle/install/dbca.rsp'], Exec['post_install_root', 'install_listener'] ],
    notify => Exec['zero_disk']
  }

  file {'/etc/oratab':
    owner => 'oracle',
    group => 'oinstall',
    mode => 0664,
    source => 'puppet:///modules/oracle/oratab',
    require => Exec['create_database']
  }
  
  file {'/etc/rc.d/init.d/oracle':
    owner => 'root',
    group => 'root',
    mode => 0755,
    source => 'puppet:///modules/oracle/init.oracle',
    require => Exec['create_database']
  }
  
  exec {'register_oracle_startup_script':
    command => '/sbin/chkconfig --add oracle; /sbin/chkconfig oracle on',
    user => root,
    require => File['/etc/oratab', '/etc/rc.d/init.d/oracle']
  }
  
  exec {'start_oracle':
    command => '/etc/rc.d/init.d/oracle start',
    user => 'root',
    creates => '/var/lock/subsys/oracle',
    require => Exec['register_oracle_startup_script']
  }
}
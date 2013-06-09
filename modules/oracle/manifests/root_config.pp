class oracle::root_config {
  include oracle::params
  include oracle::user
  
  file{'/etc/sysctl.conf':
    owner => 'root',
    group => 'root',
    mode => '0600',
    source => 'puppet:///modules/oracle/sysctl.conf'
  }
  
  file {'/etc/pam.d/login':
    owner => 'root',
    group => 'root',
    mode => '0600',
    source => 'puppet:///modules/oracle/pamd.login'
  }
  
  file {'/etc/security/limits.conf':
    owner => 'root',
    group => 'root',
    mode => '0600',
    source => 'puppet:///modules/oracle/limits.conf'
  }
  
  file {'/etc/oraInst.loc':
    owner => 'oracle',
    group => 'oinstall',
    mode => '0660',
    source => 'puppet:///modules/oracle/oraInst.loc',
    require => [ User['oracle'], Group['oinstall'] ]
  }
  
  exec{'update_sysctl':
    command => '/sbin/sysctl -p',
    user => 'root',
    require => File['/etc/sysctl.conf']
  }
}
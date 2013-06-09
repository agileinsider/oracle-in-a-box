class oracle::user {
  include oracle::packages
  
  group {'dba':
    ensure =>  present
  }

  group {'oinstall':
    ensure => present
  }
  
  file {'/app':
    ensure => directory,
  }

  file {'/app/oracle':
    ensure => directory,
    mode => 0775,
    require => File['/app']
  }
  
  file {'/app/oracle/local':
    ensure => directory,
    owner => 'oracle',
    group => 'oinstall',
    mode => 0775,
    require => [ File['/app/oracle'], User['oracle'], Group['oinstall']]
  }
  
  file {'/etc/profile.d/oracle.sh':
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => 'puppet:///modules/oracle/profile'
  }
  
  file {'/app/oracle/data':
    ensure => directory,
    owner => 'oracle',
    group => 'dba',
    mode => 0770,
    require => [ File['/app/oracle'], User['oracle'], Group['dba']]
  }
  
  user {'oracle':
    password => sha1('password'),
    gid => 'oinstall',
    groups => 'dba',
    home => '/app/oracle',
    require => [ File['/app/oracle', '/etc/profile.d/oracle.sh'], 
                 Group['oinstall', 'dba'], 
                 Package ['binutils', 
                          'compat-libcap1', 'compat-libstdc++-33', 'compat-libstdc++-33.i686', 
                          'elfutils-libelf', 'elfutils-libelf-devel', 
                          'glibc', 'glibc.i686', 'glibc-common', 'glibc-devel', 
                          'gcc', 'gcc-c++', 
                          'libaio', 'libaio-devel', 
                          'libgcc', 'libstdc++', 'libstdc++-devel', 
                          'make', 'sysstat', 
                          'unixODBC', 'unixODBC-devel',
                          'ksh',
                          'glibc-devel.i686',
                          'libgcc.i686',
                          'libstdc++.i686', 'libstdc++-devel.i686',
                          'libaio.i686', 'libaio-devel.i686',
                          'unixODBC.i686', 'unixODBC-devel.i686' ] ]
  }  
}
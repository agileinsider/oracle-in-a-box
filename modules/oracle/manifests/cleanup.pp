class oracle::cleanup {
  include oracle::user
  
  Exec { path => ['/usr/local/sbin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/bin', '/bin', '/app/oracle/local/product/11.2.0.1.0/db_in_box/bin'] }

  exec {"zero_disk":
    command => 'dd if=/dev/zero of=/tmp/clean || rm /tmp/clean',
    user => 'root',
    group => 'root',
    refreshonly => true;
  }
}
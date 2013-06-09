class oracle {
  include oracle::root_config
  include oracle::user
  include oracle::installer
  include oracle::listener
  include oracle::dbca
}
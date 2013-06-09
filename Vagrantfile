Vagrant::Config.run do |config|
  config.vm.box = "centos-6.4"
  config.vm.boot_mode = :gui

  config.vm.customize ["modifyvm", :id,
                       "--name", 'oracle-vm',
                       "--memory", "4096",
                       "--cpus", "2"]
  config.vm.host_name = 'oracle-vm.in.a.box'

  config.vm.share_folder("installers", "/tmp/downloads", "downloads")

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "oracle.pp"
    puppet.options = ["--verbose"]
    puppet.module_path = "modules"
  end
end

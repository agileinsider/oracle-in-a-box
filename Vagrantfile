Vagrant.configure("2") do |config|
  config.vm.box = "centos-6.4"

  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.customize ["modifyvm", :id,
                 "--name", 'oracle-vm',
                 "--memory", "4096",
                 "--cpus", "2"]
  end

  config.vm.hostname = 'oracle-vm.in.a.box'

  config.vm.synced_folder "downloads", "/tmp/downloads"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "oracle.pp"
    puppet.options = ["--verbose"]
    puppet.module_path = "modules"
  end
end

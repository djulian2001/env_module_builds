# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.define "manager_host" do |manager|
    manager.vm.box = "centos/7"
    manager.vm.network "private_network", ip:"192.168.34.50"
    
    manager.vm.provider "virtualbox" do |vb_manager|
      vb_manager.memory = "512"
    end

  end
  
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

end

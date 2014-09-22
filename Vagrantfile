# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.vm.define "phusion" do |v|
    v.vm.provider "docker" do |d|
      d.cmd = ["/sbin/my_init", "--enable-insecure-key"]
      d.image = "phusion/baseimage"
      d.has_ssh = true
    end

    v.ssh.username = "root"
    v.ssh.private_key_path = "insecure_key"
    
    v.vm.provision "shell", inline: "echo Hello"

    v.vm.synced_folder "./keys", "/vagrant"
  end
end

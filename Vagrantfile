# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "nbserver" do |v|
    v.vm.provider "docker" do |d|
      # describe the docker image you want to run
      d.build_dir = "."
      d.build_args = ['--quiet=false']
      d.ports = ["8081:8081"]
      d.has_ssh = true

      # filesystem syncing with boot2docker as a docker host sucks.
      # instead use a virtualbox linux vm as a docker host.
      # this docker host is described by vagrant_vagrantfile
      d.vagrant_vagrantfile = "./dockerhost/Vagrantfile"
    end

  v.vm.synced_folder "./vagrant_share", "/vagrant_share"
  end
end

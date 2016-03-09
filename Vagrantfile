# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.network :private_network, ip: "192.168.33.99"
  config.vm.network :forwarded_port, guest: 22, host: 2299

  config.vm.define 'ubuntu1404-amd64' do |instance|

    # Every Vagrant virtual environment requires a box to build off of.
    instance.vm.box = 'ubuntu1404-amd64'

    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system.
    instance.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'

    # View the documentation for the provider you're using for more
    # information on available options.
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "test.yml"
      ansible.verbose = 'vv'
      ansible.sudo = true
    end
  end
end

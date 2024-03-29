# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "moodle-with-bitoj-berkshelf"
 
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  # Set the version of chef to install using the vagrant-omnibus plugin
  # config.omnibus.chef_version = :latest

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bit-ubuntu-12.04-server-i386"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://mirror.bit.edu.cn/vagrant/boxes/bit-ubuntu-12.04-server-i386.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :private_network, type: "dhcp"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 7080

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://172.28.128.1:3128/"
    config.proxy.https    = "http://172.28.128.1:3128/"
    config.proxy.no_proxy = "localhost,127.0.0.1,.bit.edu.cn"
  end

  config.vm.provision :chef_solo do |chef|

    chef.json = {
      :ubuntu => {
	:archive_url => "http://mirror.bit.edu.cn/ubuntu",
	:security_url => "http://mirror.bit.edu.cn/ubuntu",
	:locale => "en_US.UTF-8"
      },
      :apt => {
        :compiletime => true
      },
      mysql: {
        server_root_password: '',
        server_debian_password: 'debpass',
        server_repl_password: 'replpass'
      }
    }

    chef.run_list = [
        "recipe[ubuntu]",
        "recipe[apt]",
        "recipe[apache2]",
        "recipe[apache2::mod_php5]",
        "recipe[php]",
        "recipe[mysql::server]",
        "recipe[mysql::client]",
        "recipe[moodle-with-bitoj::moodle]",
        "recipe[moodle-with-bitoj::bitoj]"
    ]
  end
end

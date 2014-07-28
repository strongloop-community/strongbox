# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$apt_bootstrap = <<-SCRIPT
  test -f bootstrapped.txt && exit
  apt-get update -y -qq
  apt-get install -y -qq build-essential git curl vim
  touch bootstrapped.txt
SCRIPT

$yum_bootstrap = <<-SCRIPT
  test -f bootstrapped.txt && exit
  yum update -y -q
  yum install -y -q git curl vim
  yum groupinstall -y -q "Development Tools"
  touch bootstrapped.txt
SCRIPT

$install_node = <<-SCRIPT
  which node && exit
  curl -s http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz | \
    tar -C /usr/local --strip-components 1 -xz -f -
  chown -R vagrant /usr/local
SCRIPT

$github = <<-SCRIPT
  grep github.com /etc/ssh/ssh_known_hosts || ssh-keyscan github.com >> /etc/ssh/ssh_known_hosts
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "ubuntu1404" do |ubuntu|
    ubuntu.vm.box = "ubuntu/trusty64"
    ubuntu.vm.provision "shell", inline: $apt_bootstrap
  end

  config.vm.define "ubuntu1204" do |ubuntu|
    ubuntu.vm.box = "ubuntu/precise64"
    ubuntu.vm.provision "shell", inline: $apt_bootstrap
  end

  config.vm.define "centos65" do |centos|
    centos.vm.box = "box-cutter/centos65"
    centos.vm.provision "shell", inline: $yum_bootstrap
  end

  # Install the latest node stable
  config.vm.provision "shell", inline: $install_node

  # Pre-populate github ssh public keys for seamless github access
  config.vm.provision "shell", inline: $github

  # Allow agent forwarding to that github works when you 'vagrant ssh'
  config.ssh.forward_agent = true

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3000, host: 3030, auto_correct: true
  config.vm.network "forwarded_port", guest: 7000, host: 7070, auto_correct: true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # In case you want a VM with more than 512MB of memroy
  config.vm.provider "virtualbox" do |vb|
    # default is 1 cpu, 512MB of RAM
    # 512 is sufficient for intended usage
    # vb.memory = 1024
    # 2 cpus allows proper node clustering
    vb.cpus = 2
  end
end

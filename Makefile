all: docker vagrant.box

docker:
	docker build --pull -t strongloop/strongbox:ubuntu ubuntu
	docker build -t strongloop/strongbox:node node
	docker build -t strongloop/strongbox:dev dev

vagrant.box: Vagrantfile
	vagrant destroy --force ubuntu1404
	vagrant up ubuntu1404
	# reboot, to make sure we have the latest kernel
	vagrant reload ubuntu1404
	vagrant ssh ubuntu1404 -c 'sudo -n apt-get purge -y linux-.*-3.13.0-5[45]-.* libx11-.* xfonts-.*'
	vagrant ssh ubuntu1404 -c 'wget http://download.virtualbox.org/virtualbox/5.0.0/VBoxGuestAdditions_5.0.0.iso'
	vagrant ssh ubuntu1404 -c 'sudo -n mkdir /media/VBoxGuestAdditions'
	vagrant ssh ubuntu1404 -c 'sudo -n mount -o loop,ro VBoxGuestAdditions_5.0.0.iso /media/VBoxGuestAdditions'
	vagrant ssh ubuntu1404 -c 'sudo -n /media/VBoxGuestAdditions/VBoxLinuxAdditions.run --nox11 -- --force || echo "mostly worked"'
	vagrant ssh ubuntu1404 -c 'sudo -n umount -f /media/VBoxGuestAdditions || echo failed to unmount'
	vagrant ssh ubuntu1404 -c 'rm VBoxGuestAdditions_5.0.0.iso'
	vagrant ssh ubuntu1404 -c 'sudo -n rmdir /media/VBoxGuestAdditions'
	vagrant ssh ubuntu1404 -c 'wget -qO- https://get.docker.com/ | sudo -n sh'
	vagrant ssh ubuntu1404 -c 'sudo -n usermod -a -G docker vagrant || echo "cannot add user to docker group"'
	vagrant reload ubuntu1404
	vagrant ssh ubuntu1404 -c 'sudo -n apt-get -y autoremove; sudo -n apt-get autoclean; sudo -n apt-get clean'
	vagrant ssh ubuntu1404 -c 'sudo -n rm -rf /var/lib/apt/lists/* boostrapped.txt'
	vagrant ssh ubuntu1404 -c 'npm install -g strongloop && npm cache clear'
	vagrant ssh ubuntu1404 -c 'dd if=/dev/zero of=zero bs=1M; rm -f zero .bash_history'
	vagrant ssh ubuntu1404 -c 'cat /etc/issue && node --version && npm --version && slc --version && docker version'
	rm -rf $@
	vagrant package --output $@ ubuntu1404

.PHONY: all

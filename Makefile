all: docker vagrant.box

docker:
	docker build --pull -t strongloop/strongbox:ubuntu ubuntu
	docker build -t strongloop/strongbox:node node
	docker build -t strongloop/strongbox:dev dev

vagrant.box: Vagrantfile
	vagrant destroy --force ubuntu1404
	vagrant up ubuntu1404
	vagrant ssh ubuntu1404 -c 'sudo apt-get dist-upgrade -y -qq; sudo apt-get autoclean'
	vagrant ssh ubuntu1404 -c 'sudo rm -rf /var/lib/apt/lists/* boostrapped.txt'
	vagrant ssh ubuntu1404 -c 'rm -rf /usr/local/src/node /usr/local/etc/npmrc'
	vagrant ssh ubuntu1404 -c 'npm install -g strongloop && npm cache clear'
	vagrant ssh ubuntu1404 -c 'dd if=/dev/zero of=zero bs=1M; rm -f zero .bash_history'
	vagrant ssh ubuntu1404 -c 'cat /etc/issue && node --version && npm --version && slc --version'
	rm -rf $@
	vagrant package --output $@ ubuntu1404

.PHONY: all

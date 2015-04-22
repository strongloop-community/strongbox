all: docker vagrant.box

docker:
	docker build --pull -t strongloop/strongbox:ubuntu ubuntu
	docker build -t strongloop/strongbox:node node
	docker build -t strongloop/strongbox:dev dev

vagrant.box: Vagrantfile
	vagrant destroy --force ubuntu1404
	vagrant up ubuntu1404
	vagrant ssh ubuntu1404 -c 'npm install -g strongloop && npm cache clear && slc --version'
	rm -rf $@
	vagrant package --output $@ ubuntu1404

.PHONY: all

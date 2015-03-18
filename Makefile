all:
	docker build --pull -t strongloop/strongbox:ubuntu ubuntu
	docker build -t strongloop/strongbox:node node
	docker build -t strongloop/strongbox:dev dev

.PHONY: all

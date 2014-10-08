all:
	docker build -t strongbox:ubuntu .
	docker build -t strongbox:node node
	docker build -t strongbox:dev dev

.PHONY: all

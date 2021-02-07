
VERSION ?= latest

image:
	docker build -t docker.io/wbuntu/mtproxy:$(VERSION) .
	@echo "build image docker.io/wbuntu/mtproxy:$(VERSION)"

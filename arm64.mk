DOCKERHUB_REPONAME=ghcr.io/bearfield
CONTAINER_NAME=debian-fish
CONTAINER_TAG=test.bookworm


MAKEFILE_DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
WORK_DIR=$(MAKEFILE_DIR)

.PHONY:test.build
test.build:
	cd $(WORK_DIR)
	docker buildx build --tag=$(DOCKERHUB_REPONAME)/$(CONTAINER_NAME):$(CONTAINER_TAG) ./docker_arm64/ --platform linux/arm64

.PHONY:test.rmi
test.rmi:
	docker rmi $(DOCKERHUB_REPONAME)/$(CONTAINER_NAME):$(CONTAINER_TAG)

.PHONY:test
test: test.build test.rmi
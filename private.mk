DOCKERHUB_REPONAME=ghcr.io/bearfield
CONTAINER_NAME=debian-fish
CONTAINER_TAG=test.bookworm-private


MAKEFILE_DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
WORK_DIR=$(MAKEFILE_DIR)

.PHONY:test.build
test.build:
	cd $(WORK_DIR)
	docker buildx build --build-arg USER_ID=1000 --tag=$(DOCKERHUB_REPONAME)/$(CONTAINER_NAME):$(CONTAINER_TAG) ./docker

.PHONY:test.rmi
test.rmi:
	docker rmi $(DOCKERHUB_REPONAME)/$(CONTAINER_NAME):$(CONTAINER_TAG)

.PHONY:test
test: test.build test.rmi
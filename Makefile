.PHONY: all build image image-branch push push-branch

SHELL := /bin/bash
IMAGE_NAME = codeocean/s3proxy
REGISTRY ?= 524950183868.dkr.ecr.us-east-1.amazonaws.com
TAG ?= $(shell ./make-tag.sh)
BRANCH ?= $(CIRCLE_BRANCH)

all: build

build:
	docker build -t $(IMAGE_NAME) . -f Dockerfile.test

image:
	docker build -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME):latest $(REGISTRY)/$(IMAGE_NAME):latest
	if [ -n "$(TAG)" ]; then \
		docker tag $(IMAGE_NAME):latest $(REGISTRY)/$(IMAGE_NAME):$(TAG); \
	fi

image-branch:
	docker build -t $(IMAGE_NAME) .
	if [ -n "$(BRANCH)" ]; then \
		docker tag $(IMAGE_NAME):latest $(REGISTRY)/$(IMAGE_NAME):$(BRANCH); \
	fi

push:
	if [ -n "$(TAG)" ]; then \
		`aws ecr get-login --region us-east-1 --no-include-email`; \
		docker push $(REGISTRY)/$(IMAGE_NAME):latest | cat; \
		docker push $(REGISTRY)/$(IMAGE_NAME):$(TAG) | cat; \
	fi

push-branch:
	if [ -n "$(BRANCH)" ]; then \
		`aws ecr get-login --region us-east-1 --no-include-email`; \
		docker push $(REGISTRY)/$(IMAGE_NAME):$(BRANCH) | cat; \
	fi

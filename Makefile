.PHONY: all build

SHELL := /bin/bash
IMAGE_NAME = codeocean/s3proxy

all: build

build:
	docker build -t $(IMAGE_NAME) . -f Dockerfile.test

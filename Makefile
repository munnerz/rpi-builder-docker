.PHONY: builder stage0 stage1
PWD:=$(shell pwd)

clean:
	rm -Rf _out/

image:
	make -f builder/Makefile img

build-docker:
	docker build -t "rpi-rootfs:stage0" -f stage0/Dockerfile stage0/ # build stage0
	docker build -t "rpi-rootfs:stage1" -f stage1/Dockerfile stage1/ # build stage2

export: build-docker
	mkdir -p _out/
	docker run --name=rootfs-stage1 --entrypoint=/bin/sh rpi-rootfs:stage1
	docker export rootfs-stage1 > _out/rootfs.tar
	docker rm rootfs-stage1

builder: export
	docker build -t rpi-builder -f builder/Dockerfile .

build: builder
	docker run -v "${PWD}/_out":/build/_out --privileged rpi-builder sh -c "make image"

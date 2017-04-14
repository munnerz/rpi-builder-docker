# This Dockerfile defines a builder image that can
# be used to build a bootable IMG for Raspberry Pi
#
# If you're already running Linux with Docker installed
# and configured, you shouldn't need this image
FROM ubuntu:16.04

RUN apt-get update \
	&& apt-get install -y \
		parted \
		curl \
		make \
		rsync \
		dosfstools \
		udev

ADD . /build

WORKDIR /build

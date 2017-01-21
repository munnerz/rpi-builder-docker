# This Dockerfile defines a builder image that can
# be used to build a bootable IMG for Raspberry Pi
#
# If you're already running Linux with Docker installed
# and configured, you shouldn't need this image
FROM docker:dind

RUN apk update \
	&& apk add \
		curl \
		make \
		rsync \
		parted \
		dosfstools \
		multipath-tools # for kpartx

ADD . /build

WORKDIR /build

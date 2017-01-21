# This defines the base layer for our raspberry pi image
# It's responsible for providing a minimally configured debian
# system and installing an appropriate bootloader & kernel.
#
# Build as `rpi-rootfs:stage0`
#
FROM armhf/debian:jessie

LABEL sys.architecture="armv7hf"

# Include a statically linked build of qemu-arm-static
# so this image can be built on a x86 machine
ADD qemu-arm-static /usr/bin/qemu-arm-static

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://archive.raspbian.org/raspbian jessie main contrib non-free rpi firmware" >>  /etc/apt/sources.list \
	&& apt-key adv --keyserver pgp.mit.edu  --recv-key 0x9165938D90FDDD2E \
	&& echo "deb http://archive.raspberrypi.org/debian jessie main" >>  /etc/apt/sources.list.d/raspi.list \
	&& apt-key adv --keyserver pgp.mit.edu  --recv-key 0x82B129927FA3303E \
	&& apt-key adv --keyserver pgp.mit.edu --recv-keys 0x4404DDEE92BF1079

# Install systemd and raspberry pi bootloader
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		systemd \
		raspberrypi-bootloader \
		raspberrypi-kernel \
	&& apt-get dist-upgrade -y \
	&& rm -rf /var/lib/apt/lists/*

ADD files/entry.sh /entry.sh

STOPSIGNAL 37
VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT ["/entry.sh"]

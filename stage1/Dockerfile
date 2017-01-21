# This stage makes a bootable filesystem.
# It configures /etc/fstab, configures the bootloader and
# kernel, sets up the network and installs packages like
# rpi-config
#
# Build as rpi-rootfs:stage1
#
FROM rpi-rootfs:stage0

RUN apt-get update \
	&& apt-get install -y \
		libraspberrypi-bin \
		libraspberrypi0 \
		raspi-config \
	&& rm -rf /var/lib/apt/lists/*

ADD files/ /

# Setup default user accounts
RUN adduser --disabled-password --gecos "" pi \
	&& echo "pi:raspberry" | chpasswd \
	&& echo "root:root" | chpasswd

# Set up hostname
RUN echo "raspberrypi" > /etc/hostname \
	&& echo "127.0.1.1 raspberrypi" >> /etc/hosts

# TODO: /lib/udev/rules.d/75-persistent-net-generator.rules changes

#!/bin/bash
IMG_OUT=$1
BOOT_SIZE=$2

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${IMG_OUT}
	  o # clear the in memory partition table
	  n # new partition
	  p # primary partition
	  1 # partition number 1
	    # default - start at beginning of disk 
	  +${BOOT_SIZE} # boot parttion size
	  n # new partition
	  p # primary partition
	  2 # partion number 2
	    # default, start immediately after preceding partition
	    # default, extend partition to end of disk
	  a # make a partition bootable
	  1 # bootable partition is partition 1 -- /dev/sda1
	  t # change partition type
	  1 # change type of boot partition
	  c # change type to 'W95 FAT32 (LBA)'
	  p # print the in-memory partition table
	  w # write the partition table
	  q # and we're done
	EOF

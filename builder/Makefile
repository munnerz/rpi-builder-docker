$(shell losetup -a | awk '{print $1}' | sed -e 's/://g' | xargs -n 1 kpartx -s -d)
$(shell losetup -a | awk '{print $1}' | sed -e 's/://g' | xargs -n 1 losetup -d)

ROOTFS_SIZE?=1G
BOOTPART_SIZE?=64M
OUT_DIR=$(shell pwd)/_out
IMG_DIR?=${OUT_DIR}/img
IMG_OUT?=${IMG_DIR}/rpi.img

LO_DEV:=$(shell losetup -f)
DEV_PREFIX:=$(shell losetup -f)

MOUNT_DIR?=${OUT_DIR}/mnt
ROOTFS_MOUNT_DIR=${MOUNT_DIR}/rootfs
BOOT_MOUNT_DIR=${MOUNT_DIR}/boot

clean:
	-@umount "${ROOTFS_MOUNT_DIR}"
	-@umount "${BOOT_MOUNT_DIR}"
	-@rm -R "${OUT_DIR}" # remove old output data

mkimg:
	mkdir -p "${IMG_DIR}"
	dd if=/dev/zero of="${IMG_OUT}" bs=1 count=0 seek=${ROOTFS_SIZE}

partitionimg: mkimg
	# create partition table
	parted "${IMG_OUT}" mktable msdos
	parted "${IMG_OUT}" mkpart primary fat32 0% "${BOOTPART_SIZE}"
	parted "${IMG_OUT}" mkpart primary ext4 "${BOOTPART_SIZE}" 100%
	parted "${IMG_OUT}" set 1 boot on
	parted "${IMG_OUT}" print
	# format partitions
	losetup --show -f -P "${IMG_OUT}"
	mkfs.fat -F 32 "${DEV_PREFIX}p1"
	mkfs.ext4 "${DEV_PREFIX}p2"

mountimg: partitionimg
	# create mount point directories
	mkdir -p "${ROOTFS_MOUNT_DIR}" "${BOOT_MOUNT_DIR}"
	mount "${DEV_PREFIX}p1" "${BOOT_MOUNT_DIR}"
	mount "${DEV_PREFIX}p2" "${ROOTFS_MOUNT_DIR}"

write-rootfs: mountimg
	# untar rootfs to mount directory
	tar -x -C "${ROOTFS_MOUNT_DIR}/" -f "${OUT_DIR}/rootfs.tar"

write-bootfs: write-rootfs
	rsync -a "${ROOTFS_MOUNT_DIR}/boot/" "${BOOT_MOUNT_DIR}/"

img: write-rootfs write-bootfs
	# unmount partitions
	umount "${ROOTFS_MOUNT_DIR}"
	umount "${BOOT_MOUNT_DIR}"
	losetup -d "${LO_DEV}"

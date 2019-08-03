#!/bin/bash -e
#
# Copyright (c) 2015 Robert Nelson <robertcnelson@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

DIR="$PWD"
TEMPDIR=$(mktemp -d)

###
imagename="beaglebone-getting-started-$(git log -1 --date=short --pretty=format:%cd)"
image_size_mb="18"
image_format="fat"
###

check_root () {
	if ! [ $(id -u) = 0 ] ; then
		echo "$0 must be run as sudo user or root"
		exit 1
	fi
}

check_for_command () {
	if ! which "$1" > /dev/null ; then
		echo -n "You're missing command $1"
		NEEDS_COMMAND=1
		if [ -n "$2" ] ; then
			echo -n " (consider installing package $2)"
		fi
		echo
	fi
}

detect_software () {
	unset NEEDS_COMMAND

	if [ "x${image_format}" = "xfat" ] ; then
		check_for_command mkfs.vfat dosfstools
		check_for_command partprobe parted
		check_for_command kpartx kpartx
	elif [ "x${image_format}" = "xiso" ] ; then
		check_for_command xorriso xorriso
	fi

	if [ "${NEEDS_COMMAND}" ] ; then
		echo ""
		echo "Your system is missing some dependencies"
		echo ""
		exit
	fi

	unset test_sfdisk
	test_sfdisk=$(LC_ALL=C sfdisk -v 2>/dev/null | grep 2.17.2 | awk '{print $1}')
	if [ "x${test_sdfdisk}" = "xsfdisk" ] ; then
		echo ""
		echo "Detected known broken sfdisk:"
		echo "See: https://github.com/RobertCNelson/netinstall/issues/20"
		echo ""
		exit
	fi
}

drive_error_ro () {
	echo "-----------------------------"
	echo "Error: for some reason your SD card is not writable..."
	echo "Check: is the write protect lever set the locked position?"
	echo "Check: do you have another SD card reader?"
	echo "-----------------------------"
	echo "Script gave up..."

	exit
}

sfdisk_partition_layout () {
	sfdisk_options="--force --in-order --Linux --unit M"
	sfdisk_boot_startmb="1"
	sfdisk_boot_fstype="0xE"

	test_sfdisk=$(LC_ALL=C sfdisk --help | grep -m 1 -e "--in-order" || true)
	if [ "x${test_sfdisk}" = "x" ] ; then
		echo "log: sfdisk: 2.26.x or greater detected"
		sfdisk_options="--force"
		sfdisk_boot_startmb="${sfdisk_boot_startmb}M"
	fi

	LC_ALL=C sfdisk ${sfdisk_options} "${media}" <<-__EOF__
		${sfdisk_boot_startmb},,${sfdisk_boot_fstype},-
	__EOF__

	sync
}

format_partition_error () {
	echo "LC_ALL=C ${mkfs} ${mkfs_partition} ${mkfs_label}"
	echo "Failure: formating partition"
	exit
}

format_partition_try2 () {
	echo "-----------------------------"
	echo "BUG: [${mkfs_partition}] was not available so trying [${mkfs}] again in 5 seconds..."
	partprobe ${media}
	sync
	sleep 5
	echo "-----------------------------"

	echo "Formating with: [${mkfs} ${mkfs_partition} ${mkfs_label}]"
	echo "-----------------------------"
	LC_ALL=C ${mkfs} ${mkfs_partition} ${mkfs_label} || format_partition_error
	sync
}

format_partition () {
	echo "Formating with: [${mkfs} ${mkfs_partition} ${mkfs_label}]"
	echo "-----------------------------"
	LC_ALL=C ${mkfs} ${mkfs_partition} ${mkfs_label} || format_partition_try2
	sync
}

format_boot_partition () {
	mkfs_partition="${media_prefix}${media_partition}"
	mkfs="mkfs.vfat -F 16"
	mkfs_label="-n BEAGLEBONE"
	format_partition
}

create_partitions () {
	media_partition=1

	echo "Using sfdisk to create partition layout"
	echo "Version: `LC_ALL=C sfdisk --version`"
	echo "-----------------------------"
	sfdisk_partition_layout

	echo "Partition Setup:"
	echo "-----------------------------"
	LC_ALL=C fdisk -l "${media}"
	echo "-----------------------------"

	media_loop=$(losetup -f || true)
	if [ ! "${media_loop}" ] ; then
		echo "losetup -f failed"
		echo "Unmount some via: [sudo losetup -a]"
		echo "-----------------------------"
		losetup -a
		echo "sudo kpartx -d /dev/loopX ; sudo losetup -d /dev/loopX"
		echo "-----------------------------"
		exit
	fi

	losetup ${media_loop} "${media}"
	kpartx -av ${media_loop}
	sleep 5
	sync
	test_loop=$(echo ${media_loop} | awk -F'/' '{print $3}')
	if [ -e /dev/mapper/${test_loop}p${media_partition} ] ; then
		media_prefix="/dev/mapper/${test_loop}p"
	else
		echo "ls -lh /dev/mapper/"
		ls -lh /dev/mapper/
		echo "Error: not sure what to do (new feature)."
		exit
	fi

	format_boot_partition
}

file_copy () {
	echo "Copying Files"
	if [ -d ./App ] ; then
		cp -rv ./App ${TEMPDIR}/disk/
	fi
	if [ -d ./Drivers ] ; then
		cp -rv ./Drivers ${TEMPDIR}/disk/
	fi
	if [ -d ./static ] ; then
		cp -rv ./static ${TEMPDIR}/disk/
	fi
	if [ -d ./scripts ] ; then
		cp -rv ./scripts ${TEMPDIR}/disk/
	fi

	if [ -f autorun.inf ] ; then
		cp -v autorun.inf ${TEMPDIR}/disk/
	fi
	if [ -f LICENSE.txt ] ; then
		cp -v LICENSE.txt ${TEMPDIR}/disk/
	fi
	if [ -f README.htm ] ; then
		cp -v README.htm ${TEMPDIR}/disk/
	fi
	if [ -f README.md ] ; then
		cp -v README.md ${TEMPDIR}/disk/
	fi
	if [ -f START.htm ] ; then
		cp -v START.htm ${TEMPDIR}/disk/
	fi
	echo "-----------------------------"
}

populate_partition () {
	echo "Populating Partition"
	echo "-----------------------------"

	if [ ! -d ${TEMPDIR}/disk ] ; then
		mkdir -p ${TEMPDIR}/disk
	fi

	mount_partition_format="vfat"
	partprobe ${media}
	if ! mount -t ${mount_partition_format} ${media_prefix}${media_partition} ${TEMPDIR}/disk; then

		echo "-----------------------------"
		echo "BUG: [${media_prefix}${media_partition}] was not available so trying to mount again in 5 seconds..."
		partprobe ${media}
		sync
		sleep 5
		echo "-----------------------------"

		if ! mount -t ${mount_partition_format} ${media_prefix}${media_partition} ${TEMPDIR}/disk; then
			echo "-----------------------------"
			echo "Unable to mount ${media_prefix}${media_partition} at ${TEMPDIR}/disk to complete populating Boot Partition"
			echo "Please retry running the script, sometimes rebooting your system helps."
			echo "-----------------------------"
			exit
		fi
	fi

	lsblk | grep -v sr0
	file_copy

	cd ${TEMPDIR}/disk
	sync
	cd "${DIR}"/
	echo "Space Used..."
	df -h ${media_prefix}${media_partition}
	echo "-----------------------------"

	umount ${TEMPDIR}/disk || umount -l ${TEMPDIR}/disk || true

	sync
	kpartx -d ${media_loop} || true
	losetup -d ${media_loop} || true

	echo "Image file: ${media}"
	echo "-----------------------------"
}

detect_software
if [ "x${image_format}" = "xfat" ] ; then
	media="${DIR}/${imagename}.img"
	check_root
	if [ -f "${media}" ] ; then
		rm -rf "${media}" || true
	fi
	dd if=/dev/zero of="${media}" bs=1024 count=0 seek=$((1024 * ${image_size_mb}))

	check_root
	create_partitions
	populate_partition
elif [ "x${image_format}" = "xiso" ] ; then
	rm -f ${imagename}.iso
	xorrisofs -r -J -o ${imagename}.iso -graft-points \
		App=./App \
		Drivers=./Drivers \
		static=./static \
		scripts=./scripts \
		autorun.inf \
		LICENSE.txt \
		README.htm \
		README.md \
		START.htm
fi

if [ -f ${imagename}.img ] ; then
	echo "-----------------------------"
	chown -R 1000:1000 ${imagename}.img
	echo "img: ${imagename}.img"
	echo "-----------------------------"
	xz -z -8 -v ${imagename}.img
	echo "img: ${imagename}.img.xz"
	echo "-----------------------------"

fi

if [ -f ${imagename}.iso ] ; then
	echo "-----------------------------"
	chown -R 1000:1000 ${imagename}.iso
	echo "iso: ${imagename}.iso"
	echo "-----------------------------"
	#xz -z -8 -v ${imagename}.iso
	echo "iso: ${imagename}.iso.xz"
	echo "-----------------------------"

fi
#

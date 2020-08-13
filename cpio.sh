#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" >&2
   exit 1
fi

cd busybox/
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j 8
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- install
cd ../

cp init busybox/_install/
chmod 755 busybox/_install/init
rm -f busybox/_install/linuxrc

rm -rf _install/
cp -r busybox/_install/ .

cd _install/
rm -rf dev
mkdir -p {dev,proc,sys,lib,mnt,tmp,etc}

mknod dev/console c 5 1 # make a fake /dev/console to make sh not crash

# dont forget to setup your kernel to have
# at least 7 loop devices:
# using CONFIG_BLK_DEV_LOOP=y
# and   CONFIG_BLK_DEV_LOOP_MIN_COUNT=7

rm -rf ../initramfs.cpio
find . -print0 | cpio --null -H newc -o > ../initramfs.cpio
echo "Wrote initramfs.cpio"

chown -R $1 ../busybox
chown -R $1 ../_install
chown -R $1 ../initramfs.cpio

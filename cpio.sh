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
mkdir _install/
cp -r busybox/_install _install/

cd _install/
mkdir -p {proc,sys,etc,etc/init.d,lib,mnt,tmp}
rm -rf dev
../makenodes.sh
rm -rf ../initramfs.cpio
find . -print0 | cpio --null -H newc -o > ../initramfs.cpio
echo "Wrote initramfs.cpio"

chown -R $1 ../_install
chown -R $1 ../initramfs.cpio

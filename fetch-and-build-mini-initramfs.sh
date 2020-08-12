#!/bin/bash

set -e

echo "Cloning latest BusyBox..."

if [ ! -d "./busybox" ]; then
    git clone git://busybox.net/busybox.git -b 1_32_stable --depth=1 busybox
fi

echo "Need root privilege to continue..."

sudo rm -f busybox/.config

cp config busybox/.config

sudo ./cpio.sh $EUID

set +e

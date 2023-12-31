#!/bin/sh

# Basic initscript tasks
echo "Performing basic initscript tasks..."
dmesg -n 1
mount -t devtmpfs none /dev || { echo "Failed to mount /dev"; exit 1; }
mount -t proc none /proc || { echo "Failed to mount /proc"; exit 1; }
mount -t sysfs none /sys || { echo "Failed to mount /sys"; exit 1; }
setsid cttyhack /bin/sh || { echo "Failed to set cttyhack"; exit 1; }
echo "Done!"
echo && echo

# Welcome message
echo "Welcome to ez-admin!"
echo "Printing partitions. Please enter a partition to mount and run ez-admin on."
mkdir -p /mnt
fdisk -l

# User input for partition
echo "Please enter a partition: "
read partition

# Check if partition exists
if [ ! -b "$partition" ]; then
    echo "Partition does not exist. Exiting..."
    exit 1
fi

# Mount partition
echo "Mounting partition..."
mount $partition /mnt || { echo "Failed to mount partition"; exit 1; }

# Backup and replace Utilman.exe
echo "Backing up and replacing Utilman.exe..."
pushd /mnt/Windows/system32
cp Utilman.exe Utilman.exe.bak
cp cmd.exe Utilman.exe
popd

# Add ez-restore.bat to System32
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

# Add ez-add-user.bat to System32
echo "Adding ez-add-user.bat to System32..."
pushd /mnt/Windows/system32
touch ez-add-user.bat
echo "@echo off" > ez-add-user.bat
echo "net user Admin 1234 /add" >> ez-add-user.bat
echo "net localgroup administrators Admin /add" >> ez-add-user.bat
echo "echo Finished creating Admin user!" >> ez-add-user.bat
popd

# Add ez-remove-user.bat to System32
echo "Adding ez-remove-user.bat to System32..."
pushd /mnt/Windows/system32
touch ez-remove-user.bat
echo "@echo off" > ez-remove-user.bat
echo "net user Admin /delete" >> ez-remove-user.bat
echo "echo Finished removing Admin user!" >> ez-remove-user.bat
popd

# Unmount partition
echo "Unmounting partition..."
umount $partition || { echo "Failed to unmount partition"; exit 1; }

# Done message and reboot
echo "Done! Rebooting in 5 seconds..."
sleep 5
poweroff -f
#!/bin/bash
set -ex

echo "Starting the build process..."

# Clean up previous build
echo "Cleaning up previous build..."
rm -rf isoimage
rm -rf linux-*
rm -rf busybox-*
rm -rf syslinux-*
rm -rf minimal_linux_live.iso

# Update versions
echo "Updating versions..."
KERNEL_VERSION=6.6.8
BUSYBOX_VERSION=1.36.1
SYSLINUX_VERSION=6.03

# Download files if they do not exist
echo "Downloading files..."
[ ! -f kernel.tar.xz ] && wget -O kernel.tar.xz https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz
[ ! -f busybox.tar.bz2 ] && wget -O busybox.tar.bz2 https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2
[ ! -f syslinux.tar.xz ] && wget -O syslinux.tar.xz https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.xz

# Extract files
echo "Extracting files..."
tar -xvf kernel.tar.xz
tar -xvf busybox.tar.bz2
tar -xvf syslinux.tar.xz

# Create isoimage directory
echo "Creating isoimage directory..."
mkdir isoimage

# Build busybox
echo "Building busybox..."
cd busybox-${BUSYBOX_VERSION}
    make distclean defconfig
    sed -i "s|.*CONFIG_STATIC.*|CONFIG_STATIC=y|" .config
    make busybox install
    # Prepare init
    echo "Preparing init..."
    cd _install
        rm -f linuxrc
        mkdir dev proc sys
        cp ../../init.sh init
        chmod +x init
        # Create rootfs.gz
        echo "Creating rootfs.gz..."
        find . | cpio -R root:root -H newc -o | gzip > ../../isoimage/rootfs.gz

# Build kernel
echo "Building kernel..."
cd ../../linux-${KERNEL_VERSION}
    make mrproper defconfig bzImage
    cp arch/x86/boot/bzImage ../isoimage/kernel.gz

# Prepare isoimage
echo "Preparing isoimage..."
cd ../isoimage
    cp ../syslinux-${SYSLINUX_VERSION}/bios/core/isolinux.bin .
    cp ../syslinux-${SYSLINUX_VERSION}/bios/com32/elflink/ldlinux/ldlinux.c32 .
    echo 'default kernel.gz initrd=rootfs.gz' > ./isolinux.cfg
    # Create iso
    echo "Creating iso..."
    xorriso \
    -as mkisofs \
    -o ../minimal_linux_live.iso \
    -b isolinux.bin \
    -c boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    ./

# Return to original directory
echo "Returning to original directory..."
cd ..
set +ex

echo "Build process completed!"
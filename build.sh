#!/bin/bash
set -ex

echo "Starting the build process..."

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
[ ! -d linux-${KERNEL_VERSION} ] && tar -xvf kernel.tar.xz
[ ! -d busybox-${BUSYBOX_VERSION} ] && tar -xvf busybox.tar.bz2
[ ! -d syslinux-${SYSLINUX_VERSION} ] && tar -xvf syslinux.tar.xz

# Create isoimage directory
echo "Creating isoimage directory..."
[ ! -d isoimage ] && mkdir isoimage

# Build busybox
if [ ! -f isoimage/rootfs.gz ]; then
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
    cd ../..
    else
        rm -f isoimage/rootfs.gz
        cd busybox-${BUSYBOX_VERSION}/_install
            rm -f init
            cp ../../init.sh init
            chmod +x init
            # Create rootfs.gz
            echo "Creating rootfs.gz..."
            find . | cpio -R root:root -H newc -o | gzip > ../../isoimage/rootfs.gz
        cd ../..
fi

# Build kernel
if [ ! -f isoimage/kernel.gz ]; then
    echo "Building kernel..."
    cd linux-${KERNEL_VERSION}
        make mrproper defconfig bzImage
        cp arch/x86_64/boot/bzImage ../isoimage/kernel.gz
    cd ..
fi

# Prepare isoimage
echo "Preparing isoimage..."
rm -rf ez-admin.iso
cd isoimage
    cp ../syslinux-${SYSLINUX_VERSION}/bios/core/isolinux.bin .
    cp ../syslinux-${SYSLINUX_VERSION}/bios/com32/elflink/ldlinux/ldlinux.c32 .
    echo 'default kernel.gz initrd=rootfs.gz' > ./isolinux.cfg
    # Create iso
    echo "Creating iso..."
    xorriso \
    -as mkisofs \
    -o ../ez-admin.iso \
    -b isolinux.bin \
    -c boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    ./
cd ..

set +ex

echo "Build process completed!"
#!/bin/bash
set -ex

echo "Starting the build process..."

# Update versions
echo "Updating versions..."
KERNEL_VERSION=6.6.8
BUSYBOX_VERSION=1.36.1

# Download files if they do not exist
echo "Downloading files..."
[ ! -f kernel.tar.xz ] && wget -O kernel.tar.xz https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz
[ ! -f busybox.tar.bz2 ] && wget -O busybox.tar.bz2 https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2

# Extract files
echo "Extracting files..."
[ ! -d linux-${KERNEL_VERSION} ] && tar -xvf kernel.tar.xz
[ ! -d busybox-${BUSYBOX_VERSION} ] && tar -xvf busybox.tar.bz2

# Create isoimage directory
echo "Creating isoimage directory..."
mkdir -p isoimage/boot/grub

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

# Create grub.cfg
echo "Creating grub.cfg..."
echo 'set timeout=0
menuentry "ez-admin" {
    linux /kernel.gz
    initrd /rootfs.gz
}' > isoimage/boot/grub/grub.cfg

# Prepare isoimage
echo "Preparing isoimage..."
rm -rf ez-admin.iso
cd isoimage
    # Create grub.cfg
    echo "Creating grub.cfg..."
    echo 'set timeout=5' > grub.cfg
    echo 'set default=0' >> grub.cfg
    echo 'menuentry "My Custom Linux" {' >> grub.cfg
    echo '    linux /kernel.gz' >> grub.cfg
    echo '    initrd /rootfs.gz' >> grub.cfg
    echo '}' >> grub.cfg
    # Create iso
    echo "Creating iso..."
    grub-mkrescue -o ../ez-admin.iso .
cd ..

set +ex

echo "Build process completed!"

#!/bin/bash

BUSYBOX_VERSION=1.36.1
LINUX_VERSION=6.6.8
BASH_VERSION=5.2.21

echo "Building for Busybox $BUSYBOX_VERSION, Linux $LINUX_VERSION, and Bash $BASH_VERSION"

echo "Cleaning up..."
rm -Rf src/linux-$LINUX_VERSION
rm -Rf src/busybox-$BUSYBOX_VERSION
rm -Rf src/bash-$BASH_VERSION
rm -Rf src/initrd
rm -Rf initrd
rm -Rf ez-admin.iso

mkdir -p src
cd src
    
    # Kernel
    LINUX_MAJOR=$(echo $LINUX_VERSION | sed 's/\([0-9]*\)[^0-9].*/\1/')
    if [ ! -f linux-$LINUX_VERSION.tar.xz ]; then
        echo "Downloading kernel $LINUX_VERSION..."
        wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$LINUX_MAJOR.x/linux-$LINUX_VERSION.tar.xz
    fi
    echo "Extracting kernel..."
    tar -xf linux-$LINUX_VERSION.tar.xz
    echo "Building kernel..."
    cd linux-$LINUX_VERSION
        make defconfig
        make -j$(nproc) || exit
    cd ..

    # Busybox
    if [ ! -f busybox-$BUSYBOX_VERSION.tar.bz2 ]; then
        echo "Downloading busybox $BUSYBOX_VERSION..."
        wget https://www.busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2  
    fi
    echo "Extracting busybox..."  
    tar -xf busybox-$BUSYBOX_VERSION.tar.bz2
    echo "Building busybox..."
    cd busybox-$BUSYBOX_VERSION
        make defconfig
        sed 's/^.*CONFIG_STATIC[^_].*$/CONFIG_STATIC=y/g' -i .config
        make -j$(nproc) || exit
    cd ..

cd ..

mkdir -p initrd/boot/grub
echo "Copying kernel..."
cp src/linux-$LINUX_VERSION/arch/x86_64/boot/bzImage initrd/boot/bzImage
if [ ! -f initrd/boot/bzImage ]; then
    echo "bzImage not found"
    exit
fi

# initrd
cd initrd

    echo "Creating rootfs skeleton and installing busybox..."
    mkdir -p bin dev proc sys boot
    cd bin
        cp ../../src/busybox-$BUSYBOX_VERSION/busybox ./

        for prog in $(./busybox --list); do
            # Skip bash
            if [ "$prog" = "bash" ]; then
                continue
            fi
            ln -s /bin/busybox ./$prog
        done
    cd ..
cd ..

cd src
    if [ ! -f bash-$BASH_VERSION.tar.gz ]; then
        echo "Downloading bash $BASH_VERSION..."
        wget https://ftp.gnu.org/gnu/bash/bash-$BASH_VERSION.tar.gz
    fi
    echo "Extracting bash..."
    tar -xf bash-$BASH_VERSION.tar.gz
    echo "Building bash..."
    cd bash-$BASH_VERSION
        ./configure --prefix=/usr --without-bash-malloc
        make -j$(nproc) || exit
        make install DESTDIR=../initrd
    cd ..
cd ..

mv src/initrd/usr ./initrd/usr

cd initrd
    echo "Performing final config..."

    cat ../init.sh > init # Copy init file over

    chmod -R 777 .

    echo "Packing initrd..."
    find . | cpio -o -H newc > ../initrd/boot/initrd.img
cd ..

if [ ! -f initrd.img ]; then
    echo "initrd.img not found"
    exit
fi

# Create grub.cfg
echo 'set timeout=10
menuentry "ez-admin" {
    linux /boot/bzImage
    initrd /boot/initrd.img
    init=/init
}' > initrd/boot/grub/grub.cfg

echo "Creating iso..."

if ! command -v xorriso &> /dev/null
then
    echo "xorriso could not be found"
    exit
fi
if ! command -v grub-mkrescue &> /dev/null
then
    echo "grub-mkrescue could not be found"
    exit
fi

grub-mkrescue --compress=xz -o ez-admin.iso initrd
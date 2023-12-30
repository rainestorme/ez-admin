#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

# Update system and install required packages
sudo apt update && sudo apt upgrade -y
sudo apt-get install -y make gcc build-essential libncurses-dev bison flex libssl-dev libelf-dev xorriso mtools
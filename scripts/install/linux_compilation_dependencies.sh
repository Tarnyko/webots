#!/bin/bash

if [[ $EUID -ne 0 ]]; then
       echo "This script must be run as root"
       exit 1
fi

. /etc/os-release

if [[ $ID == "ubuntu" ]]; then
       apt update
       apt install --yes git lsb-release cmake swig libglu1-mesa-dev libglib2.0-dev libfreeimage-dev libfreetype6-dev libxml2-dev libzzip-0-13 libboost-dev libgd3 libssh-gcrypt-dev libzip-dev libreadline-dev pbzip2 libpci-dev wget libssl-dev zip unzip
       if [[ $VERSION_ID == "20.04" ]]; then
              apt install --yes libzip5
       fi
elif [[ $ID == @(rhel|centos|rocky|alma) ]]; then
       dnf config-manager --set-enabled powertools
       rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-${VERSION_ID:0:1}.noarch.rpm
       dnf install -y git redhat-lsb-core cmake swig mesa-libGLU-devel glib2-devel freetype-devel libxml2-devel boost-devel gd-devel libssh-devel libzip-devel readline-devel pciutils-devel wget openssl-devel zip unzip java-1.8.0-openjdk-devel
       dnf install -y freeimage-devel stb_image-devel stb_image_write-devel pbzip2
       dnf install -y zziplib-devel glm-devel
else
       echo "Unsupported Linux version: dependencies may not be completely installed. Only the two latest Ubuntu LTS and latest RHEL/CentOS are supported."
fi

script_full_path=$(dirname "$0")
$script_full_path/linux_runtime_dependencies.sh

#!/bin/bash

if [[ $EUID -ne 0 ]]; then
       echo "This script must be run as root"
       exit 1
fi

. /etc/os-release

if [[ $ID == "ubuntu" ]]; then
       apt update
       apt install --yes lsb-release g++ make libavcodec-extra libglu1-mesa libxkbcommon-x11-dev libxcb-keysyms1 libxcb-image0 libxcb-icccm4 libxcb-randr0 libxcb-render-util0 libxcb-xinerama0 libxcomposite-dev libxtst6 libnss3
       if [[ $VERSION_ID == @(18.04|20.04) ]]; then
              apt install --yes ffmpeg
       fi
       if [[ -z "$DISPLAY" ]]; then
              apt install --yes xvfb
       fi
elif [[ $ID == @(rhel|centos|rocky|alma) ]]; then
       dnf config-manager --set-enabled powertools
       rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-${VERSION_ID:0:1}.noarch.rpm
       rpm -ivh https://download1.rpmfusion.org/free/el/rpmfusion-free-release-${VERSION_ID:0:1}.noarch.rpm
       dnf install -y redhat-lsb-core gcc-c++ make mesa-libGLU xcb-util-keysyms xcb-util-image xcb-util-wm xcb-util-renderutil libXrandr libXinerama libXcomposite-devel libXtst nss
       dnf install -y ffmpeg
       dnf install -y libxkbcommon-x11-devel
       if [[ -z "$DISPLAY" ]]; then
              dnf install -y xorg-x11-server-Xvfb
       fi
else
       echo "Unsupported Linux version: dependencies may not be completely installed. Only the two latest Ubuntu LTS and latest RHEL/CentOS are supported."
fi

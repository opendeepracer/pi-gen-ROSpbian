#!/bin/bash -e
# Based on https://www.seeedstudio.com/blog/2019/08/01/installing-ros-melodic-on-raspberry-pi-4-and-rplidar-a1m8/

# add ros package repo
. /etc/os-release
echo "deb http://packages.ros.org/ros/ubuntu $VERSION_CODENAME main" > "${ROOTFS_DIR}/etc/apt/sources.list.d/ros-latest.list"

on_chroot << EOF
# add repo key
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# update package list
apt-get update
EOF

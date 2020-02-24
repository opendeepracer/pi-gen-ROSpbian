#!/bin/bash -e

# using a prebuilt tar ball
tar zxf files/ros-melodic-armhf.tar.gz -C ${ROOTFS_DIR}

CADIR=${ROOTFS_DIR}/usr/local/share/ca-certificates/

pushd ${CADIR} >/dev/null
# Add DigiCert SHA2 Secure Server CA 
 wget https://www.digicert.com/CACerts/DigiCertHighAssuranceEVCA-1.crt
 wget https://dl.cacerts.digicert.com/DigiCertSHA2SecureServerCA.crt
 mv DigiCertHighAssuranceEVCA-1.crt DigiCertHighAssuranceEVCA-1.der
 openssl x509 -inform DER -outform PEM -in DigiCertHighAssuranceEVCA-1.der -out DigiCertHighAssuranceEVCA-1.pem.crt
 mv DigiCertSHA2SecureServerCA.crt DigiCertSHA2SecureServerCA.der
 openssl x509 -inform DER -outform PEM -in DigiCertSHA2SecureServerCA.der -out DigicertSHA2SecureServerCA.pem.crt
popd >/dev/null

install -m 644 files/roscore.service "${ROOTFS_DIR}/etc/systemd/system"
install -m 644 files/rospberry-set-hostname.service "${ROOTFS_DIR}/etc/systemd/system"
install -m 644 files/rospberry-add-authorized-keys.service "${ROOTFS_DIR}/etc/systemd/system"

install -D -m 644 files/20-default.list "${ROOTFS_DIR}/etc/ros/rosdep/sources.list.d/20-default.list"
install -m 644 files/load-ros-env.sh "${ROOTFS_DIR}/etc/profile.d"
install -m 700 files/set-hostname.sh "${ROOTFS_DIR}/usr/local/sbin/"
install -m 700 files/update-ssh-authorized-keys.sh "${ROOTFS_DIR}/usr/local/sbin/"
install -m 644 files/020_ros-nopasswd "${ROOTFS_DIR}/etc/sudoers.d"

# fix to load ROS env for all ROS users using terminals which skip .profile 
grep -q -F "load-ros-env.sh" ${ROOTFS_DIR}/etc/bash.bashrc 2>/dev/null || echo "source /etc/profile.d/load-ros-env.sh" >> ${ROOTFS_DIR}/etc/bash.bashrc	

on_chroot << EOF
systemctl enable roscore.service
systemctl enable rospberry-set-hostname.service
systemctl enable rospberry-add-authorized-keys.service
update-ca-certificates
openssl rehash /etc/ssl/certs
EOF
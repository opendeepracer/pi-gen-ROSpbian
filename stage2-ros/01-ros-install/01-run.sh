#!/bin/bash -e

# using a prebuilt tar ball
tar zxf files/ros-melodic-armhf.tar.gz -C ${ROOTFS_DIR}

# Add DigiCert SHA2 Secure Server CA 
CADIR=${ROOTFS_DIR}/usr/local/share/ca-certificates/

pushd ${CADIR} >/dev/null
 wget https://dl.cacerts.digicert.com/DigiCertSHA2SecureServerCA.crt
 # https://dl.cacerts.digicert.com/DigiCertSHA2SecureServerCA.crt.pem
 #mv ${CADIR}/DigiCertSHA2SecureServerCA.crt.pem ${CADIR}/DigiCertSHA2SecureServerCA.pem.crt
 mv DigiCertSHA2SecureServerCA.crt DigiCertSHA2SecureServerCA.der
 openssl x509 -inform DER -outform PEM -in DigiCertSHA2SecureServerCA.der -out DigicertSHA2SecureServerCA.pem.crt
popd >/dev/null

install -m 644 files/roscore.service "${ROOTFS_DIR}/etc/systemd/system"
install -D -m 644 files/20-default.list "${ROOTFS_DIR}/etc/ros/rosdep/sources.list.d/20-default.list"
install -m 644 files/load-ros-env.sh "${ROOTFS_DIR}/etc/profile.d"

on_chroot << EOF
systemctl enable roscore.service
update-ca-certificates

EOF
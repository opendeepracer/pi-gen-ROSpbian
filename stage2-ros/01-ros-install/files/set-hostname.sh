#!/bin/bash
# This is a dangerous tool it might mess up your system. Don't use without understanding. 
# It has very little sanity checking.  
#
HOSTFILE="/etc/hosts"

CURRENTHOSTNAME=$(hostname)
NEWHOSTNAME=$1
ID=$(id -u)
if [ -z "${NEWHOSTNAME}" -o  "${CURRENTHOSTNAME}" == "${NEWHOSTNAME}"  -o  $ID -ne 0  ] ; then 
	echo usage $0 newhostname
	exit 1
fi

#NOP=echo
${NOP} hostnamectl set-hostname ${NEWHOSTNAME}

sed "s/${CURRENTHOSTNAME}/${NEWHOSTNAME}/g" ${HOSTFILE} >${HOSTFILE}.${NEWHOSTNAME}
${NOP} cp ${HOSTFILE} ${HOSTFILE}.${CURRENTHOSTNAME} 
${NOP} cp ${HOSTFILE}.${NEWHOSTNAME} ${HOSTFILE} 
echo -n "hostname: " ; hostname 
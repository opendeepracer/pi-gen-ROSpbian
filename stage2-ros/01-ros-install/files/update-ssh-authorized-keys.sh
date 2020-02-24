#!/bin/bash
# This is a dangerous tool it might mess up your system. Don't use without understanding. 
# It has very little sanity checking.  
#
KEYPATH=$1

ID=$(id -u)
if [ -z "${KEYPATH}" -o $ID -ne 0  ] ; then 
	echo usage $0 authorized_keys_list 
	exit 1
fi
CHD=$(/bin/ls $KEYPATH/* 2>/dev/null) 
if [ $? -ne 0 ] ; then
	echo cannot read $KEYPATH or is empty
	exit 1
fi

umask 0077 2>/dev/null
for KF in ${KEYPATH}/* ; do
	USERNAME=$(basename "$KF")
	ID=$(id -u "$USERNAME" 2>/dev/null)
	if [ $? -ne 0 ] ; then
		echo "unknown user $USERNAME"
	elif [ $ID -lt 1000 ] ; then
	   	echo "$USERNAME" is a system user 
	else
		HD=$(getent passwd ros | cut -d: -f6)
		if [ $? -ne 0 -o ! -d "$HD" ] ; then
			echo "Cannot change to homedir $HD of $USERNAME"
		else	
			mkdir -p $HD/.ssh 
			while IFS= read -r line ; do
				grep -q -F "$line" $HD/.ssh/authorized_keys 2>/dev/null || echo "$line" >> $HD/.ssh/authorized_keys	
			done < "$KF"
			chown --reference=$HD $HD/.ssh $HD/.ssh/authorized_keys
		fi
	fi
done

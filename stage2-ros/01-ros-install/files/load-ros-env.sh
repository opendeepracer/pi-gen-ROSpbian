#!/bin/bash

if [ -z "${ROS_DISTRO}" -a -d ".ros" ] ; then
  export ROSBASE=/opt/ros/melodic

  source ${ROSBASE}/setup.bash

  if [ ! -e ".ros/rosdep/sources.cache" ] ; then
	echo no source cache - loading.
  	rosdep update
  else
     ls -l .ros/rosdep/sources.cache/index | awk '{print "source cache refreshed on " $6,$7,$8}'
  fi
  figlet ROSpbian
  figlet $ROS_DISTRO
  echo -n "version "; rosversion -s rosmaster ; echo " (rosmaster)"
  echo loaded ros $ROSBASE/setup.bash
fi
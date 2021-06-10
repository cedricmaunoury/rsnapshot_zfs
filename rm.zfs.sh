#!/bin/sh
#####
# This script is launched by rsnapshot
# The first argument automatically sent by rsnapshot is "-rf" and won't be used
# The second and last one is the target of the cmd_rm
#####
if [ $# -ne 2 ]
then
  echo "ERROR : Wrong parameters, should be <-rf> <target>"
  exit 1
fi

Target=`echo $2 | sed 's/\/$//'`

TargetSnapDir=`ls -l $Target | sed 's/.* //'`
SnapDataset=`df -h $TargetSnapDir | tail -1 | sed 's/ .*//'`

zfs destroy $SnapDataset
if [ $? -ne 0 ]
then
  echo "ERROR : ZFS Destroy failure"
  exit 1
fi

rm $Target
if [ $? -ne 0 ]
then
  echo "ERROR : 'rm' failure"
  exit 1
fi

exit 0

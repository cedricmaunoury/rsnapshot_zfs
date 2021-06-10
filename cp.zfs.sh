#!/bin/sh
#####
# This script is launched by rsnapshot
# The first argument automatically sent by rsnapshot is "-al" and won't be used
# The second one is the source of the cmd_cp
# The third and last one is the target of the cmp_cmd
#####
if [ $# -ne 3 ]
then
  echo "ERROR : Wrong parameters, should be <-al> <sourcedir> <targetdir>"
  exit 1
fi

SourceDir=$2
TargetDir=`echo $3 | sed 's/\/$//'`

# Trying to get the dataset name mounted on $SourceDir
SourceDataset=`zfs list | egrep " ${SourceDir}$" | sed 's/ .*//'`
if [ "$SourceDataset" == "" ]
then
  echo "ERROR : <sourcedir> is not a ZFS Dataset mountpoint"
  exit 1
fi

SnapshotName=`date "+%Y%m%d-%H%M"`

zfs snapshot ${SourceDataset}@${SnapshotName}
if [ $? -ne 0 ]
then
  echo "ERROR : ZFS Snapshot failure"
  exit 1
fi

ln -s ${SourceDir}/.zfs/snapshot/${SnapshotName} ${TargetDir}
if [ $? -ne 0 ]
then
  echo "ERROR : 'ln' failure"
  exit 1
fi

exit 0

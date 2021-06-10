# rsnapshot_zfs

Author : Cédric Maunoury

Feel free to contact me for a job (https://www.linkedin.com/in/cedric-maunoury/)

This repo hosts special cmd_cp and cmd_rm commands to let rsnapshot take advantage of ZFS power. rsnapshot is a great tool to schedule backups and manage retentions (hourly, daily, weekly, ...)

When you try to manage many backups with this tool, the server may suffer from a high load especially because of I/O. The default behavior is about launching "cp" and "rm" commands on directories that may host thousands or millions of files. But rsnapshot has also a big advantage : you can customize the "cp" and "rm" commands. The goal of this repo is to provide two scripts to replace default commands with one that can take advantage of ZFS and its snapshot feature. You can even enable compression on ZFS to use more space than available :)

Using this "hack" in the past, I was able to lower the time needed for "cp" and "rm" from 6 hours each to less than 5 seconds... and the load on the backup server stopped waking me up too :)

If your most frequent backups are daily, this is what you have to do to make it work :

1. Create a configuration file like this one (be careful, use tabulations, not spaces) :
```config_version		1.2
snapshot_root		/zroot/rsnapshot/zfs
cmd_cp			/root/rsnapshot/cp.zfs.sh
cmd_rm			/root/rsnapshot/rm.zfs.sh
cmd_rsync		/usr/local/bin/rsync
cmd_ssh			/usr/bin/ssh
backup			root@localhost:/zroot/rsnapshot/source/		ROOT/
loglevel		3
logfile			/zroot/rsnapshot/log/rsnapshot.zfs

retain			daily	4
retain			weekly	3
```

2. Create zfs dataset mounted on /zroot/rsnapshot/zfs/daily.0
```
zfs create -o mountpoint=/zroot/rsnapshot/zfs/daily.0 -o compression=on -o sync=disabled -o atime=off $YourDataset
```

3. Launch the following command to ensure it is working as expected
```
rsnapshot -c $YourConfigFile daily
```

4. This is the result you should get after some runs
```
root@rsnap:~/rsnapshot # ls -al /zroot/rsnapshot/zfs/
total 12
drwxr-xr-x  3 root  wheel   7 Jun 10 13:14 .
drwxr-xr-x  7 root  wheel   7 Jun 10 10:44 ..
drwxr-xr-x  3 root  wheel   3 Jun 10 13:14 daily.0
lrwxr-xr-x  1 root  wheel  56 Jun 10 13:14 daily.1 -> /zroot/rsnapshot/zfs/daily.0/.zfs/snapshot/20210610-1314
lrwxr-xr-x  1 root  wheel  56 Jun 10 12:21 daily.2 -> /zroot/rsnapshot/zfs/daily.0/.zfs/snapshot/20210610-1221
lrwxr-xr-x  1 root  wheel  56 Jun 10 12:20 daily.3 -> /zroot/rsnapshot/zfs/daily.0/.zfs/snapshot/20210610-1220
lrwxr-xr-x  1 root  wheel  56 Jun 10 12:19 weekly.0 -> /zroot/rsnapshot/zfs/daily.0/.zfs/snapshot/20210610-1219
root@rsnap:~/rsnapshot # 
```

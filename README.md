# rsnapshot_zfs

Author : Cédric Maunoury

Special cmd_cp and cmd_rm commands to let rsnapshot take advantage of ZFS power
rsnapshot is a great tool to schedule backups and manage retentions (hourly, daily, weekly, ...)

When you try to manage many backups with this tool, the server may suffer from a high load especially because of I/O. The default behavior is about launching "cp" and "rm" commands on directories that may host thousands or millions of files. But rsnapshot has also a big advantage : you can customize the "cp" and "rm" commands. The goal of this repo is to provide two scripts to replace default commands with one that can take advantage of ZFS and its snapshot feature.

If your most frequent backups are daily, this is what you have to do to make it work :

1/Create a configuration file like this one (be careful, use tabulations, not spaces) :
config_version		1.2
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

2/Create zfs dataset mounted on /zroot/rsnapshot/zfs/daily.0

3/

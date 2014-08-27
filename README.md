mybackup
========

This is my backup script.

Setup:
* You'll need to edit the script and set your backup location, and the directories to backup.
* Add something like this to your crontab: 

```
  44 * * * * /root/backup_scripts/incremental_backup.pl -type hourly 
  33 4 * * * /root/backup_scripts/incremental_backup.pl -type daily 
  22 4 * * 1 /root/backup_scripts/incremental_backup.pl -type weekly
```

* This will, by default, keep some hourly backups, some daily backups, and some weekly backups.
  It is very space efficient; it will only keep one copy if there are no changes


This script was inspired by:
http://www.mikerubel.org/computers/rsync_snapshots/

This is good read.


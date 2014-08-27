mybackup
========

This is my backup script.

Requirements:
* rdiff-backup
 - http://packages.ubuntu.com/search?keywords=rdiff-backup
 - http://www.nongnu.org/rdiff-backup/

* mkdir

Setup:
* You'll need to edit the script and set:
  - your local backup location, 
  - your "net" backup locaiton,
  - the list of directories to backup.
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

This is a very good read. Gives a highlevel overview to the concepts of backup.


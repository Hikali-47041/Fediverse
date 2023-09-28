#!/bin/bash
# https://docs.akkoma.dev/stable/administration/backup/
# cron every friday 5:00
# `sudo crontab -e`
# 0 5 * * 5 bash <path/to>/akkoma-backup.sh

workdir="/tmp"
savedir="$HOME/akkoma-backup"
dbname="akkoma"
dbuser="postgres"
filename="hi-47041-net_$(date -I).pgdump"
backup_file_amount=5
debug_flag=true

# message
echo "akkoma-backup.sh | akkoma-backup.sh [info] backup job started"

# mkdir if $savedir does not exist
if [ ! -e "$savedir" ]
then
    mkdir -p "$savedir"
    if "$debug_flag"; then echo "akkoma-backup.sh | [debug] mkdir $savedir"; fi
fi

# backup
cd "$workdir" || exit 1
su "$dbuser" -lc "pg_dump -d $dbname --format=custom -f "$workdir/"$filename"""
if "$debug_flag"; then echo "akkoma-backup.sh [debug] pg_dump $workdir/$filename created!"; fi
mv "$workdir/$filename" "$savedir"

# remove older backup data
while [ "$(find "$savedir" -type f | wc -l)" -ge "$backup_file_amount" ]
do
    if "$debug_flag"; then echo "akkoma-backup.sh [debug] old pg_dump $savedir/$(find "$savedir" -type f | sort | head -1) removed!"; fi
    rm "$savedir/$(find "$savedir" -type f | sort | head -1)"
done

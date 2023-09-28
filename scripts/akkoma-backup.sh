#!/bin/bash
# https://docs.akkoma.dev/stable/administration/backup/
# cron every friday 5:00
# `sudo crontab -e`
# 0 5 * * 5 bash <path/to>/akkoma-backup.sh

workdir="/tmp"
savedir="$HOME/akkoma-backup"
dbname="akkoma"
filename="hi-47041-net_$(date -I).pgdump"
backup_file_amount=5

# mkdir if $savedir does not exist
if [ ! -e "$savedir" ]
then
    mkdir -p "$savedir"
fi

# backup
cd "$workdir" || exit 1
su postgres -lc "pg_dump -d $dbname --format=custom -f "$workdir/"$filename"""
mv "$workdir/$filename" "$savedir"

# remove older backup data
while [ "$(find "$savedir" -type f | wc -l)" -ge "$backup_file_amount" ]
do
    rm "$savedir/$(find "$savedir" -type f | sort | head -1)"
done

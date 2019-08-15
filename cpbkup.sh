#!/bin/bash
#This script will copy daily backups to external drive and delete oldest leaving the latest 10

#set -x will debug the application as it runs to view each step as it processes
#set -x 

#Clear variables
clear_variables() {
	count_backup="" 	oldest_backup=""	latest_backup=""
}

#Execute commands
clear_variables
count_backup=`ls -d /media/nathan/Data/Ubuntu/nathan-backups/20* | wc -l`
latest_backup=`ls /media/nathan/32GB\ Backup/timeshift/snapshots-daily/ | tail -1`
oldest_backup=`ls /media/nathan/Data/Ubuntu/nathan-backups/ | head -1`
if [ "$count_backup" -le "10" ]; then
    less10=1
else
    less10=0
fi

if [ -d /media/nathan/Data/Ubuntu/nathan-backups/$latest_backup ]; then
   dir_exists=1
else
    dir_exists=0
fi

if [ "$less10" -eq "$dir_exists" ]; then
    echo $'\n'$"$(date)  
The latest backup has already been copied to the destination drive. Exiting..." | tee -a /media/nathan/Data/Ubuntu/nathan-backups/backuplogs.log
    echo ""
elif [ "$less10" -gt "$dir_exists" ]; then
    echo $'\n'$"$(date)
+++ Copying latest backup to destination... +++
" | tee -a /media/nathan/Data/Ubuntu/nathan-backups/backuplogs.log
    echo ""
    sudo cp -rH /media/nathan/32GB\ Backup/timeshift/snapshots/$latest_backup  /media/nathan/Data/Ubuntu/nathan-backups/
    sudo mv /media/nathan/Data/Ubuntu/nathan-backups/$oldest_backup /media/nathan/Data/Ubuntu/nathan-backups/delete_me #rename directory
else
    echo $'\n'$"$(date)
+++ Renaming/Deleting oldest backup... +++
" | tee -a /media/nathan/Data/Ubuntu/nathan-backups/backuplogs.log
    echo ""
#    sudo cp -rH /media/nathan/32GB\ Backup/timeshift/snapshots/$latest_backup  /media/nathan/Data/Ubuntu/nathan-backups/
    sudo mv /media/nathan/Data/Ubuntu/nathan-backups/$oldest_backup /media/nathan/Data/Ubuntu/nathan-backups/delete_me #rename directory
fi

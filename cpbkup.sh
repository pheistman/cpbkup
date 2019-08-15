#!/bin/bash
#This script will copy daily backups to external drive and delete oldest leaving the latest 10

#set -x will debug the application as it runs to view each step as it processes
#set -x 

#Clear variables
clear_variables() {
	count_backup="" 	oldest_backup=""	latest_backup=""
}

# Location variables
usb_path='/media/nathan/32gb/timeshift'
ext_path='/media/nathan/Data/Ubuntu/nathan-backups'

#Execute commands
clear_variables
count_backup=`ls -d $ext_path/20* | wc -l`
latest_backup=`ls $usb_path/snapshots-daily/ | tail -1`
oldest_backup=`ls $ext_path/ | head -1`
if [ "$count_backup" -le "10" ]; then
    less10=1
else
    less10=0
fi

if [ -d $ext_path/$latest_backup ]; then
   dir_exists=1
else
    dir_exists=0
fi

if [ "$less10" -eq "$dir_exists" ]; then
    echo $'\n'$"$(date)  
The latest backup has already been copied to the destination drive. Exiting...
" | tee -a $ext_path/backuplogs.log
    echo ""
elif [ "$less10" -gt "$dir_exists" ]; then
    echo $'\n'$"$(date)
+++ Copying latest backup to destination... +++
" | tee -a $ext_path/backuplogs.log
    echo ""
    sudo cp -rH $usb_path/snapshots/$latest_backup $ext_path 
    sudo mv $ext_path/$oldest_backup $ext_path/delete_me #rename directory
else
    echo $'\n'$"$(date)
+++ Renaming/Deleting oldest backup... +++
" | tee -a $ext_path/backuplogs.log
    echo ""
#    sudo cp -rH $usb_path/snapshots/$latest_backup $ext_path 
    sudo mv $ext_path/$oldest_backup $ext_path/delete_me #rename directory
fi

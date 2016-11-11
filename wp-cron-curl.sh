#!/bin/bash

if [ -z "$1" ];
then 
	echo 'Expecting URL: Empty argument supplied: Script Terminated'
	exit 1;
fi 

# This runs wp-cron.php with up to 60 seconds of entropy to prevent overlap with other sites
delay=$(($RANDOM%60));

/bin/sleep $delay;
/usr/bin/curl -v $1/wp-cron.php?`date +\%s`;

#!/bin/bash
# Managed on GitHub: https://github.com/firefallpro/WordPress-Cron-Runner

# wp-cron-runner.sh
# Handles cron jobs that run wp-cron.php for various WordPress installs that share the same server
# by adding a random delay to reduce possible performance costs that would be incurred by running
# scripts concurrently. The script also appends a timestamp to prevent caching if any caching service is used.

# @version 0.0.1, 2016-11-11
# @author Scott Park <scott@firefallpro.com>, Aric Ng <aric@firefallpro.com>
# @link http://www.firefallpro.com/
# @license http://www.firefallpro.com/license.txt
# @copyright Copyright (c) 2016 Firefall, LLC

if [ -z "$1" ];
then 
	echo 'Expecting URL: Empty argument supplied: Script Terminated'
	exit 1;
fi 

# This runs wp-cron.php with up to 60 seconds of entropy to prevent overlap with other sites
delay=$(($RANDOM%60));

/bin/sleep $delay;
/usr/bin/curl -v $1/wp-cron.php?`date +\%s`;

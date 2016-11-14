#!/bin/bash
# Managed on GitHub: https://github.com/firefallpro/WordPress-Cron-Runner
#
# wp-cron-runner.sh
# This shell script handles cron jobs that run wp-cron.php for various WordPress installs that share the same server, by adding a random (up to 60 second) delay to reduce possible performance costs that would be incurred by running scripts concurrently. The script also appends a timestamp to prevent caching if any caching service is used i.e. via CloudFlare or NGINX.
#
# @version 0.0.2, 2016-11-11
# @author Scott Park <scott@firefallpro.com>, Aric Ng <aric@firefallpro.com>
# @link http://www.firefallpro.com/
# @license http://www.firefallpro.com/license.txt
# @copyright Copyright (c) 2016 Firefall, LLC

# First argument must not be empty
if [ -z "$1" ];
then 
	echo "\nwp-cron-runner.sh: Expecting URL: Empty argument supplied: Script Terminated \n" 
	exit 1;
fi 


debug=${2:-false} # Default to false
curlOption="-s -S" # Default is silent but still shows earlier

# Ensure debug is either false or true
if [ "$debug" != false ]; then
	if [ "$debug" != true ]; then
		debug=false
	elif [ "$debug" == true ]; then
		curlOption="-v"
	fi
fi
if [ "$debug" == true ]; then
	echo "\nwp-cron-runner.sh: cURL command set with -v: Verbose: Debug messages and cURL results will be displayed"
fi
#else
#	echo "\nwp-cron-runner.sh: cURL command set with -s -S: Silent with an exception for errors"
#fi

# This runs wp-cron.php with up to 60 seconds of entropy to prevent overlap with other sites
delay=$(($RANDOM%60));

if [ "$debug" == true ]; then
	echo "wp-cron-runner.sh: Sleeping for $delay secs \n"
fi

/bin/sleep $delay;
/usr/bin/curl $curlOption $1/wp-cron.php?`date +\%s`;

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
	echo "\\nwp-cron-runner.sh: Expecting URL: Empty argument supplied: Script Terminated\\n" 
	exit 1;
fi 


verbose=${2:-s -S} # Default to silent: -s -S

# Ensure verbose is either false or true
# If true, set curlOption to be "-v" for verbose
if [ "$verbose" != "-s -S" ]; then
	if [ "$verbose" != "-v" ]; then
		verbose="-s -S"
	else
		echo "\\nwp-cron-runner.sh: cURL command set with -v: Verbose: verbose messages and cURL results will be displayed"
	fi
fi

# This runs wp-cron.php with up to 60 seconds of entropy to prevent overlap with other sites
delay=$(($RANDOM%60));

if [ "$verbose" == "-v" ]; then
	echo "wp-cron-runner.sh: Sleeping for $delay secs \\n"
fi

/bin/sleep $delay;
/usr/bin/curl $verbose $1/wp-cron.php?`date +\%s`;

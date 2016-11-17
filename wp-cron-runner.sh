#!/bin/bash
# Managed on GitHub: https://github.com/firefallpro/WordPress-Cron-Runner
#
# wp-cron-runner.sh
# This shell script handles cron jobs that run wp-cron.php for various WordPress installs that share the same server, by adding a random (up to 60 second) delay to reduce possible performance costs that would be incurred by running scripts concurrently. The script also appends a timestamp to prevent caching if any caching service is used i.e. via CloudFlare or NGINX.
# i.e. /usr/local/bin/wp-cron-runner.sh http://dev.woofmints.com/wp-cron.php
#
# @version 0.0.3, 2016-11-11
# @author Scott Park <scott@firefallpro.com>, Aric Ng <aric@firefallpro.com>
# @link http://www.firefallpro.com/
# @license http://www.firefallpro.com/license.txt
# @copyright Copyright (c) 2016 Firefall, LLC
 
verbose="-s -S"
url=$1

# Look for v in options; stop script if other options are found
while getopts ":v" opt; do 
	case $opt in
		v) 
			# v found, shift options
			verbose="-v" 
			;;
		*) 
			printf "\nwp-cron-runner: Unexpected flag found: Script Terminated\n\n"
			exit 1
			;;
	esac
done

# Look for absolute url
if [[ $verbose == "-v" ]]; then
	shift $(($OPTIND-1))
	url=$1
fi

# Check if URL is empty
if [ -z "$url" ]; then
	printf "\nwp-cron-runner.sh: Expecting URL: Empty argument supplied: Script Terminated\n\n" 
	exit 1
fi

if [[ $verbose == "-v" ]]; then
	printf "\nwp-cron-runner.sh: Attempting to run cURL command on $url"
fi

# This runs wp-cron.php with up to 60 seconds of entropy to prevent overlap with other sites
delay=$(($RANDOM%60));

if [ "$verbose" == "-v" ]; then
	printf "\nwp-cron-runner.sh: Sleeping for $delay secs \n\n"
fi

/bin/sleep $delay;
/usr/bin/curl $verbose $url?`date +\%s`;

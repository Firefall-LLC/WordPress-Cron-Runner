#!/bin/bash
# Managed on GitHub: https://github.com/firefall-llc/WordPress-Cron-Runner
#
# wp-cron-runner.sh
# This shell script handles cron jobs that run wp-cron.php for various WordPress installs that share the same server, by adding a random (up to 60 second) delay to reduce possible performance costs that would be incurred by running scripts concurrently. The script also appends a timestamp to prevent caching if any caching service is used i.e. via CloudFlare or NGINX.
# i.e. /usr/local/bin/wp-cron-runner.sh http://www.example.com/wp-cron.php
#
# @version 0.1.4, 2020-04-22
# @author Scott Park <scott@firefall.com>, Aric Ng <aric@firefall.com>
# @link http://www.firefall.com/
# @license MIT License
# @copyright Copyright (c) 2020 Firefall, LLC

verbose="-s -S"
resolve=()
offset=0
url=$1 # Get first argument

print_usage() {
	printf 'Usage:\n\n/usr/local/bin/wp-cron-runner.sh http://www.example.com/wp-cron.php\n\n/usr/local/bin/wp-cron-runner.sh -v -h <host>:<port>:<ip> http://example.com/wp-cron.php\n\n'
}

# Look for v in options; stop script if other options are found
while getopts ":vh:" opt; do
	case $opt in
		v)
			# v found, shift options
			printf "\nwp-cron-runner: Verbose mode\n\n"
			verbose="-v"
			offset=$((offset + 1))
			;;
		h)
			# h found, set --resolve and its argument for curl
			# argument should be similar to example.com:80:10.0.1.1
			resolve=(--resolve "$OPTARG")

			offset=$((offset + 2))
			;;
		*)
			printf "\nwp-cron-runner: Unexpected flag found: -%s: Script Terminated\n\n" "$OPTARG"
			print_usage
			exit 1
			;;
	esac
done

# Look for absolute url after offset
for ((c = 0; c < offset; c++))
do
	shift $((OPTIND - 1))
done

url=$1

# Check if URL is empty
if [ -z "$url" ]; then
	printf "\nwp-cron-runner.sh: Expecting URL: Empty argument supplied: Script Terminated\n\n"
	print_usage
	exit 1
fi

if [[ $verbose == "-v" ]]; then
	printf "\nwp-cron-runner.sh: Attempting to run cURL command on %s" "$url?$(date +%S)"

	if [ ${#resolve[@]} -eq 2 ]; then
		printf " with host %s" "${resolve[1]}"
	fi
fi

# This runs wp-cron.php with up to 60 seconds of entropy to prevent overlap with other sites
delay=$((RANDOM % 60));

if [ "$verbose" == "-v" ]; then
	printf "\nwp-cron-runner.sh: Sleeping for %s secs \n\n" "$delay"
fi

/bin/sleep $delay && /usr/bin/curl --ipv4 $verbose "${resolve[@]}" "$url?$(date +%S)";

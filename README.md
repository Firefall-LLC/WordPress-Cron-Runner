This shell script handles cron jobs that run wp-cron.php for various WordPress installs that share the same server, by adding a random (up to 60 second) delay to reduce possible performance costs that would be incurred by running scripts concurrently. The script also appends a timestamp to prevent caching if any caching service is used i.e. via CloudFlare or NGINX.

Script requires an absolute URL as its first argument. The second argument is optional, if set to "true", then the script will be verbose, along with the cURL command.

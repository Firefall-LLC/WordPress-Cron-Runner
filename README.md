This shell script handles cron jobs that run wp-cron.php for various WordPress installs that share the same server, by adding a random (up to 60 second) delay to reduce possible performance costs that would be incurred by running scripts concurrently. The script also appends a timestamp to prevent caching if any caching service is used i.e. via CloudFlare or NGINX.

Script requires an absolute URL to wp-cron.php as its first argument. 


By default the script will include "-s -S" to be silent but not for errors. 
"-v" will cause the script to be verbose. 
"-h" and its argument ```<host>:<port>:<ip> example.com:80:10.0.1.1 ``` will set the --resolve curl option
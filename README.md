# WordPress Cron Runner

This shell script handles cron jobs that run wp-cron.php for various WordPress installs that share the same server, by adding a random (up to 60 second) delay to reduce possible performance costs that would be incurred by running scripts concurrently. The script also appends a timestamp to prevent caching if any caching service is used i.e. via CloudFlare or NGINX.

Before running this script `define('DISABLE_WP_CRON', 'true');` must be added to wp-config.php.

Script requires an absolute URL to wp-cron.php as its first argument.

```
./wp-cron-runner.sh http://example.com/wp-cron.php
```

By default the script will include "-s -S" to be silent but not for errors.
* "-v": Sets script in verbose mode, debug messages will be displayed
* "-h": With argument in the format of ```<host>:<port>:<ip>``` i.e. ```example.com:80:10.0.1.1``` will call the given url at the specified ip address

With all options set, the command should look like this:

```
./wp-cron-runner.sh -v -h example.com:80:10.0.1.1 http://example.com/wp-cron.php
```

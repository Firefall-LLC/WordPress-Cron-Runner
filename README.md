Shell script that allow various WordPress installation's wp-cron.php to automatically bust cache in both CloudFlare and NGINX; each with their own delay to prevent conconcurrent runtimes, when called via cron job.

Script requires an absolute URL as its first and only argument

TODO: Add verbose flag as part of arguments to enable verbose mode in curl request
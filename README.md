iphitch
=======

A bash script that pushes out email alerts upon IP change. Uses cron and an external email account.

install
=======

Clone to desired location and configure the script.
You'll need mailx and msmtp configured to work with a gmail account or similar setup.

Set a cron job to run the script every 5 min:

<code>$ sudo crontab -e -u <user> </code>
and add:
*/5 * * * * /home/jrd/code/iphitch/iphitch.sh > /dev/null 2>&1

Iphitch
=======

A bash script that pushes out email alerts upon IP change. Uses cron and an external email account.
Can randomize the list of servers and cycle through on failed connections.

Install
=======

Clone to desired location and configure the script.
You'll need mailx and msmtp configured to work with a gmail account or similar setup.

Set a cron job to run the script every 5 min:

<code>$ sudo crontab -e -u <user> </code>
and add:
*/5 * * * * ~/iphitch/iphitch > /dev/null 2>&1

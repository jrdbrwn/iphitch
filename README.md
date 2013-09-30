iphitch
=======

A bash script that pushes out email alerts upon IP change. Uses cron and an external email account.


install
=======
Set a cron job to run our script every 5 min:

$ sudo crontab -e -u <user>

*/5 * * * * /home/jrd/code/iphitch/iphitch.sh > /dev/null 2>&1

#!/bin/bash

#List of emails to receive the info
EMAILS=( 'foo@bar.com' )

#List of sites that return visitors IP address with HTTP
#GET_IP_SITES=( 'icanhazip.com' 'echoip.com' 'myip.dnsdynamic.com' 'ifconfig.me' );
GET_IP_SITES=( 'myip.dnsdynamic.com' 'ifconfig.me' 'icanhazip.com' 'echoip.com' );


#This is where we'll store the IP address
IP_FILE=~/.currentip

#Log file
LOG_FILE=~/.iphitch.log

#If true the GET_IP_SITES will be shuffled
MIXED=false

#Keeps count of where the script is
SITE_COUNT=0
EMAIL_COUNT=0
SITE_POSITION=0


if [[ $MIXED -eq true ]]; then

	echo "no random connection yet"
fi

while [  $SITE_COUNT -lt ${#GET_IP_SITES[@]} ]; do
#Gets the output and puts the HTTP status down, discards error message
# -q disabling curlrc
# -S shows error messages
# -s muting curl
# -f fail silently
# -w write out display on success
echo -e "\nConnecting to:${GET_IP_SITES[$SITE_POSITION]} [$SITE_POSITION]..."
OUTPUT=$( curl -qSfsw '\n%{http_code}' ${GET_IP_SITES[$SITE_POSITION]} ) 2>/dev/null
#echo $OUTPUT
#Gets curl's exit code
ERROR=$?

#Pulls needed variables from OUTPUT 
CURLEDIP=$( echo "$OUTPUT" | head -n-1 ) 
STOREDIP=$( cat $IP_FILE )
echo -e "$( date +%Y-%m-%d\(%H:%M:%S\) ) Curled IP: $CURLEDIP Curl Error:$ERROR - HTTP Error: $HTTPSTATUS" >> $LOG_FILE
echo "$ERROR"

	#Here we do some error checking on the exit code from curl
	if [ $ERROR -ne 0 ] ; then
	#	echo "$ERROR"
		#Logs error to file	
		echo "$( date +%Y-%m-%d\(%H:%M:%S\) ) Curl Error:$ERROR - HTTP Error: $HTTPSTATUS" >> $LOG_FILE

	fi

	#If curl can't resolve a site we try the next one
	if [[ $ERROR -eq 6 ]]; then
		

		BLACKLIST+=( $SITE_POSITION )
		echo "Couldn't resolve host. The given remote host was not resolved. "
		echo -e "$( date +%Y-%m-%d\(%H:%M:%S\) ) Couldn't resolve host. The given remote host was not resolved." >> $LOG_FILE

		echo "BLACKLIST now contains ${BLACKLIST[@]}"
		echo "BLACKLIST with SITE_COUNT AT $SITE_COUNT: ${BLACKLIST[$SITE_COUNT]}"
		let SITE_COUNT=SITE_COUNT+1
		echo "Updated SITE_COUNT is $SITE_COUNT"
		echo "*************"
		SITE_POSITION=$SITE_COUNT

	elif [[ $ERROR -eq 7 ]]; then

		echo -e "$( date +%Y-%m-%d\(%H:%M:%S\) ) Couldn't resolve host. The given remote host was not resolved." >> $LOG_FILE
		let SITE_COUNT=SITE_COUNT+1
		SITE_POSITION=$SITE_COUNT
	else
		#If the curled IP is different
		if [[ "$CURLEDIP" != "$STOREDIP" ]]; then

			echo -e "$( date +%Y-%m-%d\(%H:%M:%S\) ) $CURLEDIP has replaced $STOREDIP" >> $LOG_FILE
	
			#Update the stored IP
			echo ${CURLEDIP} > $IP_FILE

			#Send off Email			
		#echo "${GET_IP_SITES[$SITE_COUNT]} returns $CURLEDIP" | mail -s "The IP fo $HOSTNAME has changed" -c "b.jared@gmail.com,thenautilusmachine@gmail.com"

			while [  $EMAIL_COUNT -lt ${#EMAILS[@]} ]; do
				echo "${GET_IP_SITES[$SITE_COUNT]} returns $CURLEDIP" | mail -s "The IP for $HOSTNAME has changed" ${EMAILS[$EMAIL_COUNT]}
				echo -e "$( date +%Y-%m-%d\(%H:%M:%S\) ) $CURLEDIP has been emailed to ${#EMAILS[@]}" >> $LOG_FILE
				let EMAIL_COUNT=EMAIL_COUNT+1
			done	
		fi
		#This ends the while loop
		break

	fi

done

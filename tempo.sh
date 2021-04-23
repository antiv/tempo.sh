#!/bin/bash
# tempo.sh - read loged data
# Tested with Tempo 8.0.2
#
# Usage `TEMPOTOKEN=aaaa-bbb-bbb-cccc TEMPOUSERNAME=user.name tempo.sh`
#
# Use it from crontab eg.
# 10 9-18 * * 1-5 TEMPOTOKEN=aaaa-bbb*bbb*cccc TEMPOUSERNAME=user.name /path/to/script/tempo.sh


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

MIN=${MIN:-8}

TEMPOTOKEN=${TEMPOTOKEN:-xxx-xxx-xxx}
TEMPOUSERNAME=${TEMPOUSERNAME:-user.name}
JIRAURL=${JIRAURL:-"https://jira.yourcompany.com"}
DATEFROM=$(date +%Y-%m-%d -d "1 day ago")
FROMDAY='yesterday'

if [[ $(date +%u) -eq 1 ]] 
then 
	DATEFROM=$(date +%Y-%m-%d -d "3 day ago"); 
	FROMDAY='Friday'
fi

echo -e "Get data from $RED$DATEFROM$NC"

hours=$(/usr/bin/curl -s --location --request GET "${JIRAURL}/plugins/servlet/tempo-getWorklog/?dateFrom=${DATEFROM}&format=xml&diffOnly=false&tempoApiToken=${TEMPOTOKEN}&userName=${TEMPOUSERNAME}"|/usr/bin/grep -oP "(?<=<hours>)[^<]+")
array=($hours)

SUM=0
for element in "${array[@]}"
do
    SUM=$(/usr/bin/echo "$SUM + $element"|/usr/bin/bc -l)
done

if (( $(/usr/bin/echo "$SUM < $MIN" | /usr/bin/bc -l) ));
then
	/usr/bin/echo -e "You are logged $RED$SUM$NC hours fom $FROMDAY!"
	/usr/bin/notify-send  -t 3000 -u normal "You are logged only $SUM hours from $FROMDAY!" 'Please go to: https://jira.braintribe.com/secure/TempoUserView.jspa and log your work!'
else
	/usr/bin/echo -e "You are logged $GREEN$SUM$NC hours from $FROMDAY!"
fi

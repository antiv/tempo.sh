# tempo.sh
Summarizes your logged hours in the jira Tempo for the previous day and sends a notification if sum is less than 8 hours


NOTE: Tested with Tempo 8.0.2

# Set as executable

`chmod +x tempo.sh`

# Usage 

`TEMPOTOKEN=aaaa-bbb-bbb-cccc TEMPOUSERNAME=user.name tempo.sh`

`TEMPOTOKEN=aaaa-bbb-bbb-cccc TEMPOUSERNAME=user.name MIN=7.5 tempo.sh`


# Use it from crontab eg.

At minute 10 past every hour from 9 through 18 on every day-of-week from Monday through Friday.

`10 9-18 * * 1-5 TEMPOTOKEN=aaaa-bbb*bbb*cccc TEMPOUSERNAME=user.name /path/to/script/tempo.sh`

# Dependencies

1. curl
2. bc
3. notify-send


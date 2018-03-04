#!/bin/bash
[ -z "${CERT_DOMAIN}" ] && { echo "=> CERT_DOMAIN cannot be empty" && exit 1; }
[ -z "${CRON_TIME}" ] && { echo "=> CRON_TIME cannot be empty" && exit 1; }

touch /cron.log
tail -F /cron.log &

echo "${CRON_TIME} /cron.sh >> /cron.log 2>&1" > /crontab.conf
crontab /crontab.conf
echo "=> Running cron task manager"
exec crond -f


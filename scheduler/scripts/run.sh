#!/bin/bash

set -e

while ! nc -z mongodb 27017; do
  echo "waiting for mongodb listening..."
  sleep 1
done
echo "MongoDB started"

# prepare and restore database
/scripts/create.sh
/scripts/restore.sh

# make env accessible to cron
declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

# install crontab
sed -e "s#\${BACKUP_SCHEDULE}#$BACKUP_SCHEDULE#" /crontab > /etc/cron.d/scheduler
chmod +x /etc/cron.d/scheduler
crontab /etc/cron.d/scheduler

echo "Starting cron"
cron -f

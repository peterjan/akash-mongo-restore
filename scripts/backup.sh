#!/bin/bash

# Check if another instance of script is running
pidof -o %PPID -x $0 >/dev/null && echo "ERROR: Script $0 already running" && exit 1

set -e

echo "Backing up database"
mongodump --quiet \
          --db=$MONGODB_DATABASE \
          --username=$MONGODB_USERNAME \
          --password=$MONGODB_PASSWORD \
          --authenticationDatabase admin \
          --archive=db.archive

echo "Encrypting backup"
gpg --symmetric \
    --batch \
    --passphrase $SKYNET_SEED \
    db.archive.gpg

rm db.archive

echo "Uploading backup"
skylinkv2 update $SKYNET_DATAKEY db.archive.gpg
rm db.archive.gpg

echo "Backup complete"

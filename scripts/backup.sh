#!/bin/bash

# Check if another instance of script is running
pidof -o %PPID -x $0 >/dev/null && echo "ERROR: Script $0 already running" && exit 1

set -e

echo "Backing up database"
mongodump --host=mongodb:27017 \
          --username=$MONGODB_USERNAME \
          --password=$MONGODB_PASSWORD \
          --authenticationDatabase=admin  \
          --db=$MONGODB_DATABASE  \
          --archive=db.archive

echo "Encrypting backup"
gpg --symmetric \
    --batch \
    --passphrase $SKYNET_SEED \
    db.archive
rm db.archive

echo "Uploading backup"
skylinkv2 update $SKYNET_DATAKEY db.archive.gpg --keyfile /tmp/keys.txt
rm db.archive.gpg

echo "Backup complete"

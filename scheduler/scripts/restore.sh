#!/bin/bash

# Check if another instance of script is running
pidof -o %PPID -x $0 >/dev/null && echo "ERROR: Script $0 already running" && exit 1

set -e

echo "Restoring database"

echo "Downloading backup"
skylinkv2 fetch $SKYNET_DATAKEY db.archive.gpg --keyfile /tmp/keys.txt

# TODO: this should be an empty file check, but due to a bug we can't download
# empty files yet, so we upload a date string, which is 62 bytes...
if (( $(stat -c%s "db.archive.gpg") < 80 )); then
    echo "Backup does not contain database dump"
    exit 0
fi

echo "Decrypting backup"
gpg --decrypt \
    --batch \
    --passphrase $SKYNET_SEED \
    db.archive.gpg > db.archive
rm db.archive.gpg

echo "Restoring from backup"
mongorestore --host=mongodb:27017 \
             --username=$MONGODB_USERNAME \
             --password=$MONGODB_PASSWORD \
             --authenticationDatabase=admin  \
             --db=$MONGODB_DATABASE  \
             --archive=db.archive
rm db.archive

echo "Restore complete."


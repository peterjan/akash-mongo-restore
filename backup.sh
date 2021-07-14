#!/bin/bash

# TODO: check if process is running

export MONGO_DB_NAME = $MONGO_DB_NAME
export SKYNET_SEED = $SKYNET_SKYLINK_V2
export SKYNET_DATAKEY = $SKYNET_SKYLINK_V2
export SKYNET_PORTAL_URL = $SKYNET_PORTAL_URL
export BACKUP_PASSPHRASE = $BACKUP_PASSPHRASE

echo "Backing up database $MONGO_DB_NAME"
mongodump --quiet --db=launchpad-v4-staging

echo "Compressing database dump"
tar -czf dump.tgz dump
rm -rf dump

if [ -n "$BACKUP_PASSPHRASE" ]; then
    echo "Encrypting database dump"
    gpg --symmetric --batch --passphrase "$BACKUP_PASSPHRASE" dump.tgz
    rm dump.tgz
    local_file="dump.tgz.gpg"
    s3_uri="${s3_uri}.gpg"
else
    echo "No encryption"
    local_file="dump.tgz"

fi

echo "Uploading dump to Skynet"


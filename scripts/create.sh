#!/bin/bash

# Check if another instance of script is running
pidof -o %PPID -x $0 >/dev/null && echo "ERROR: Script $0 already running" && exit 1

set -e

echo "Creating Skylink V2"
skylinkv2 keys $SKYNET_SEED --keyfile /tmp/keys.txt
skylinkv2 create $SKYNET_DATAKEY --keyfile /tmp/keys.txt
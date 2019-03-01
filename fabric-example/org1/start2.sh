#!/bin/bash

# Exit on first error, print all commands.
set -ev

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

cp -rf ../org2/config/logistics.block ../org1/config

# now run the end to end script
docker exec org1Cli scripts/script2.sh
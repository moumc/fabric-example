#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error, print all commands.
set -ev

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

#docker-compose -f docker-compose-cli.yaml down

docker-compose -f docker-compose-cli.yaml up -d 

# sleep 1

# now run the end to end script
docker exec org1Cli scripts/script.sh 


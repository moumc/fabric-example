#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error, print all commands.
set -e

# Shut down the Docker containers for the system tests.
#docker-compose -f docker-compose-order.yaml kill && docker-compose -f docker-compose-order.yaml down

# remove chaincode docker images
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

docker volume prune 

docker rmi $(docker images dev-* -q)

docker-compose -f ./order/docker-compose-order.yaml down

set +e
# Your system is now clean

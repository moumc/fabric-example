#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
CHANNEL_NAME=product

# remove previous crypto material and config transactions
rm -fr config/*
#rm -fr crypto-config/*

# generate crypto material
#cryptogen generate --config=./crypto-config.yaml
#if [ "$?" -ne 0 ]; then
#  echo "Failed to generate crypto material..."
#  exit 1
#fi

#=============================================#

CHANNEL_NAME=logistics

# generate channel configuration transaction
configtxgen -profile LogisticsChannel -outputCreateChannelTx ./config/logistics_channel.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile LogisticsChannel -outputAnchorPeersUpdate ./config/LogisticsOrg1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile LogisticsChannel -outputAnchorPeersUpdate ./config/LogisticsOrg2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile LogisticsChannel -outputAnchorPeersUpdate ./config/LogisticsOrg3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile LogisticsChannel -outputAnchorPeersUpdate ./config/LogisticsOrg4MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org4MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi

#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}
CHANNEL_NAME=mychannel

# remove previous crypto material and config transactions
rm -fr config/*
#rm -fr crypto-config/*

# generate crypto material
#cryptogen generate --config=./crypto-config.yaml
#if [ "$?" -ne 0 ]; then
#  echo "Failed to generate crypto material..."
#  exit 1
#fi

# generate genesis block for orderer
configtxgen -profile FourOrgsOrdererGenesis -outputBlock ./config/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi


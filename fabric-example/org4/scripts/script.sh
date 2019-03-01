#!/bin/bash

echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "Build network (demo)"
echo

CHANNEL_NAME="product"
DELAY=3
LANGUAGE=golang
TIMEOUT=10
VERBOSE=false

LANGUAGE=`echo "$LANGUAGE" | tr [:upper:] [:lower:]`
COUNTER=1
MAX_RETRY=10

CC_SRC_PATH="github.com/chaincode/product/go/"
CHAINCODE="product"

echo "Channel name : "$CHANNEL_NAME

# import utils
. ./scripts/utils.sh

createChannel() {
	setGlobals 0 1

	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
                set -x
		peer channel create -o orderer0.example.com:7050 -c $CHANNEL_NAME -f ./config/product_channel.tx >&log.txt
		res=$?
                set +x
	else
				set -x
		peer channel create -o orderer0.example.com:7050 -c $CHANNEL_NAME -f ./config/product_channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
		res=$?
				set +x
	fi
	cat log.txt
	verifyResult $res "Channel creation failed"

    cp -rf $CHANNEL_NAME.block ./config

	echo "===================== Channel '$CHANNEL_NAME' created ===================== "
	echo
}

joinChannel () {
	# for org in 1 2; do
	    # for peer in 0 1; do
        peer=0
        org=4
		joinChannelWithRetry $peer $org
		echo "===================== peer${peer}.org${org} joined channel '$CHANNEL_NAME' ===================== "
		sleep $DELAY
		echo
	    # done
	# done
}

## Create channel
# echo "Creating channel..."
# createChannel

cp -rf config/$CHANNEL_NAME.block ./

## Join all the peers to the channel
echo "Having all peers join the channel..."
joinChannel

## Set the anchor peers for each org in the channel
echo "Updating anchor peers for org1..."
updateAnchorPeers 0 4
# echo "Updating anchor peers for org2..."
# updateAnchorPeers 0 2

## Install chaincode on peer0.org1 and peer0.org2
echo "Installing chaincode on peer0.org1..."
installChaincode 0 4  1.0 ${CHAINCODE}
# echo "Install chaincode on peer0.org2..."
# installChaincode 0 2

# # Instantiate chaincode on peer0.org2
# echo "Instantiating chaincode on peer0.org2..."
# instantiateChaincode 0 4 1.0 ${CHAINCODE}

# # Query chaincode on peer0.org1
# echo "Querying chaincode on peer0.org1..."
# chaincodeQuery 0 1 100

# # Invoke chaincode on peer0.org1 and peer0.org2
# echo "Sending invoke transaction on peer0.org1 peer0.org2..."
# chaincodeInvoke 0 1 0 2

# ## Install chaincode on peer1.org2
# echo "Installing chaincode on peer1.org2..."
# installChaincode 1 2

# # Query on chaincode on peer1.org2, check if the result is 90
# echo "Querying chaincode on peer1.org2..."
# chaincodeQuery 1 2 90

echo
echo "========= All GOOD, BYFN execution completed =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

exit 0



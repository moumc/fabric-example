#!/bin/sh

echo 'Stop Application'
pm2 stop org4-invoke >/dev/null 2>&1
pm2 stop org3-invoke >/dev/null 2>&1
pm2 stop org2-invoke >/dev/null 2>&1
pm2 stop org1-invoke >/dev/null 2>&1

echo 'Stop Blockchain Explorer'
cd ./blockchain-explorer
./stop.sh

echo 'Stop Fabric Network'
cd ../
./teardown.sh
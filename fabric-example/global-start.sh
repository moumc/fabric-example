#!/bin/sh

echo 'Generate Crypto Start'
#./generate-crypto.sh
#cd ../org1
#./generate-crypto.sh

#cd ../org2
#./generate-crypto.sh

#cd ../org3
#./generate-crypto.sh

#cd ../org4
#./generate-crypto.sh
echo 'Generate Crypto End'

echo 'Copy Crypto Start'
cd ./order
./copy-crypto.sh
cd ../org1
./copy-crypto.sh
cd ../org2
./copy-crypto.sh
cd ../org3
./copy-crypto.sh
cd ../org4
./copy-crypto.sh
echo 'Copy Crypto End'

echo 'Generate Config File Start'
cd ../order
./generate.sh

cd ../org1
./generate.sh

cd ../org2
./generate.sh

cd ../org3
./generate.sh

cd ../org4
./generate.sh
echo 'Generate Config File End'

echo 'Orderers Start'
cd ../order
./start.sh
echo 'Orderers End'

export FABRIC_START_TIMEOUT=10
echo " Wait for Hyperledger Fabric to start: ${FABRIC_START_TIMEOUT}s"
sleep ${FABRIC_START_TIMEOUT}

echo 'Organizations Step 1 Start'
cd ../org1
./start.sh

cd ../org2
./start.sh

cd ../org3
./start.sh

cd ../org4
./start.sh
echo 'Organizations Step 1 End'

echo 'Organizations Step 2 Start'
cd ../org1
./start2.sh

cd ../org3
./start2.sh

cd ../org4
./start2.sh
echo 'Organizations Step 2 End'

echo 'Instantiating Chaincode Start'
echo 'Instantiating org1'
docker exec org1Cli peer chaincode query -C logistics -n logistics -c '{"Args":["queryProduct","1"]}'  >/dev/null 2>&1
docker exec org1Cli peer chaincode query -C logistics -n mycc -c '{"Args":["query","a"]}'  >/dev/null 2>&1
echo 'Instantiating org2'
docker exec org2Cli peer chaincode query -C logistics -n mycc -c '{"Args":["query","a"]}'  >/dev/null 2>&1
echo 'Instantiating org3'
docker exec org3Cli peer chaincode query -C product -n product -c '{"Args":["queryProduct","1"]}'  >/dev/null 2>&1
docker exec org3Cli peer chaincode query -C logistics -n logistics -c '{"Args":["queryProduct","1"]}'  >/dev/null 2>&1
echo 'Instantiating org4'
docker exec org4Cli peer chaincode query -C product -n product -c '{"Args":["queryProduct","1"]}'  >/dev/null 2>&1
docker exec org4Cli peer chaincode query -C logistics -n logistics -c '{"Args":["queryProduct","1"]}'  >/dev/null 2>&1
docker exec org4Cli peer chaincode query -C logistics -n mycc -c '{"Args":["query","a"]}'  >/dev/null 2>&1
echo 'Instantiating Chaincode End'

sleep 5

echo 'Application Start'
cd ../org1/app
pm2 start invoke.js -n org1-invoke
sleep 5

cd ../../org2/app
pm2 start invoke.js -n org2-invoke
cd ../../org3/app
pm2 start invoke.js -n org3-invoke
cd ../../org4/app
pm2 start invoke.js -n org4-invoke
echo 'Application End'

echo 'Blockchain Explorer Start'
cd ../../blockchain-explorer/app/persistence/fabric/postgreSQL/db
./createdb.sh
cd ../../../../../
./start.sh
echo 'Blockchain Explorer End'

echo 'Start All'
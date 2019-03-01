/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { FileSystemWallet, Gateway } = require('fabric-network');
const fs = require('fs');
const path = require('path');
const sleep = require('sleep');

const ccpPath = path.resolve(__dirname, '..', 'connection.json');
const ccpJSON = fs.readFileSync(ccpPath, 'utf8');
const ccp = JSON.parse(ccpJSON);

async function main(networkid, chaincodeid, info) {
    try {

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        // console.log(`Wallet path: ${walletPath}`);
        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists('user1');
        if (!userExists) {
            console.log('An identity for the user "user1" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }
        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'user1', discovery: { enabled: false } });
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork(networkid);
        // Get the contract from the network.
        const contract = network.getContract(chaincodeid);

        if (chaincodeid === 'product') {
            // Submit the specified transaction.
            // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')
            // changeCarOwner transaction - requires 2 args , ex: ('changeCarOwner', 'CAR10', 'Dave')
            await contract.submitTransaction('addOrg1Info', info.ID, info.Name, info.Address, info.ProductionDate);
            console.log('Transaction has been submitted');
        } else if (chaincodeid === 'mycc') {
            // Submit the specified transaction.
            // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')
            // changeCarOwner transaction - requires 2 args , ex: ('changeCarOwner', 'CAR10', 'Dave')
            await contract.submitTransaction('invoke', info.para1, info.para2, info.para3);
            console.log('Transaction has been submitted');
        }

        // Disconnect from the gateway.
        await gateway.disconnect();

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
}

let id = 1;
let flag = true;

function getInfo(chaincodeid) {
    let info = {};
    if (chaincodeid === 'mycc') {
        info.para1 = flag ? 'a' : 'b';
        info.para2 = flag ? 'b' : 'a';
        info.para3 = '10';
        flag = !flag;
    } else {
        info.ID = id.toString();
        info.Name = 'milk';
        info.Address = 'Shenzhen Longhua District Merchants View Garden';
        let time = new Date().toLocaleString();
        info.ProductionDate = time;
        id++;
    }

    return info;
}

async function start() {
    while (1)  {
        // let chaincodeid = 'mycc';
        // let networkid = 'logistics';
        //
        // let info = getInfo(chaincodeid);
        // console.log(info);
        //
        // await main(networkid, chaincodeid, info);

        let chaincodeid = 'product';
        let networkid = 'product';
        let info = getInfo(chaincodeid);

        // console.log(info);
        await main(networkid, chaincodeid, info);

        sleep.sleep(5);
    }
}

start();
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

async function main(info) {
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
        const network = await gateway.getNetwork('logistics');

        // Get the contract from the network.
        const contract = network.getContract('logistics');

        // Submit the specified transaction.
        // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')
        // changeCarOwner transaction - requires 2 args , ex: ('changeCarOwner', 'CAR10', 'Dave')

        await contract.submitTransaction('addOrg2Info', info.ID, info.Company, info.ReceivingTime, info.ArrivalTime, info.Sender, info.Recipient, info.TransportPeriod);
        console.log('Transaction has been submitted');

        // Disconnect from the gateway.
        await gateway.disconnect();

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
}

let id = 1;

function getYestoday() {
    return new Date(new Date().getTime() - 1000 * 60 * 60 * 24).toLocaleString();
}

function getToday() {
    return new Date().toLocaleString();
}

function getInfo() {
    let info = {};

    info.ID = id.toString();
    info.Company = 'SF';
    info.ReceivingTime = getYestoday();
    info.ArrivalTime = getToday();
    info.Sender = 'xiaoming';
    info.Recipient = 'zhangsan';
    info.TransportPeriod = '24 hour';

    id++;

    return info;
}

async function start() {
    while (1)  {
        let info = getInfo();

        // console.log(info);
        await main(info);

        sleep.sleep(5);
    }
}

start();
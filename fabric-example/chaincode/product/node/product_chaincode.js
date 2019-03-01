'use strict';
const shim = require('fabric-shim');
const util = require('util');

let Chaincode = class { 
    async Init(stub) {
        let ret = stub.getFunctionAndParameters();
        console.info(ret);
        console.info('=========== Instantiated Product Chaincode ===========');
        return shim.success();
    }

    async Invoke(stub) {
        console.info('Transaction ID: ' + stub.getTxID());
        console.info(util.format('Args: %j', stub.getArgs()));
    
        let ret = stub.getFunctionAndParameters();
        console.info(ret);
    
        let method = this[ret.fcn];
        if (!method) {
          console.log('no function of name:' + ret.fcn + ' found');
          throw new Error('Received unknown function ' + ret.fcn + ' invocation');
        }
        try {
          let payload = await method(stub, ret.params, this);
          return shim.success(payload);
        } catch (err) {
          console.log(err);
          return shim.error(err);
        }
    }
    
    async org1AddInfo(stub, args, thisClass) {
        if (args.length != 4) {
            throw new Error('Incorrect number of arguments. Expecting 4');
        }
        console.info('--- start org1AddInfo ---')
        if (args[0].lenth <= 0) {
          throw new Error('1st argument must be a non-empty string');
        }
        if (args[1].lenth <= 0) {
          throw new Error('2nd argument must be a non-empty string');
        }
        if (args[2].lenth <= 0) {
          throw new Error('3rd argument must be a non-empty string');
        }
        if (args[3].lenth <= 0) {
          throw new Error('4th argument must be a non-empty string');
        }

        let productID = args[0];
        let name = args[1].toLowerCase();
        let address = args[3].toLowerCase();
        let productionDate = parseInt(args[2]);

        if (typeof productionDate !== 'number') {
            throw new Error('3rd argument must be a numeric string');
        }

        let productState = await stub.getState(productID);
        if (productState.toString()) {
          throw new Error('This product already exists: ' + productState);
        }

        let product = {};
        product.docType = 'product';
        product.productID = productID;
        product.name = name;
        product.productionAddress = address;
        product.productionDate = productionDate;

        // === Save product to state ===
        await stub.putState(productID, Buffer.from(JSON.stringify(product)));

        console.info('- end org1AddInfo');
    }
    
    async org3AddInfo(stub, args, thisClass) {
        if (args.length != 4) {
            throw new Error('Incorrect number of arguments. Expecting 4');
        }
        console.info('--- start org3AddInfo ---')
        if (args[0].lenth <= 0) {
          throw new Error('1st argument must be a non-empty string');
        }
        if (args[1].lenth <= 0) {
          throw new Error('2nd argument must be a non-empty string');
        }
        if (args[2].lenth <= 0) {
          throw new Error('3rd argument must be a non-empty string');
        }
        if (args[3].lenth <= 0) {
            throw new Error('4th argument must be a non-empty string');
        }

        let productID = args[0];
        let salesMethod = args[1].toLowerCase();
        let salesAddress = args[2].toLowerCase();
        let receiptTime = parseInt(args[3]);

        if (typeof receiptTime !== 'number') {
            throw new Error('0rd argument must be a numeric string');
        }

        let productState = await stub.getState(productID);
        if (!productState.toString()) {
          throw new Error('This product not exists: ' + productState);
        }

        let product = JSON.parse(productState.toString());
        console.log(product);

        product.salesMethod = salesMethod;
        product.salesAddress = salesAddress;
        product.receiptTime = receiptTime;

        // === Save product to state ===
        await stub.putState(productID, Buffer.from(JSON.stringify(product)));

        console.info('- end org3AddInfo');
    }

    async org4AddInfo(stub, args, thisClass) {
        if (args.length != 2) {
            throw new Error('Incorrect number of arguments. Expecting 2');
        }
        console.info('--- start org4AddInfo ---')
        if (args[0].lenth <= 0) {
          throw new Error('1st argument must be a non-empty string');
        }
        if (args[1].lenth <= 0) {
          throw new Error('2nd argument must be a non-empty string');
        }

        let productID = args[0];
        let price = args[1];

        let productState = await stub.getState(productID);
        if (!productState.toString()) {
          throw new Error('This product not exists: ' + productState);
        }

        let product = JSON.parse(productState.toString());
        console.log(product);

        product.price = price;

        // === Save product to state ===
        await stub.putState(productID, Buffer.from(JSON.stringify(product)));

        console.info('- end org4AddInfo');
    }

    async queryProduct(stub, args, thisClass) {
        //   0
        // 'queryString'
        if (args.length < 1) {
          throw new Error('Incorrect number of arguments. Expecting queryString');
        }
        let productID = args[0];
        if (!productID) {
          throw new Error('productID must not be empty');
        }

        let productState = await stub.getState(productID);
        if (!productState.toString()) {
            throw new Error('This product not exists: ' + productState);
        }

        // console.log(productState);
        // console.log(JSON.stringify(productState));

        return productState;
    }
    
};

shim.start(new Chaincode());
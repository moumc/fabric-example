package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/core/chaincode/shim/ext/cid"
	sc "github.com/hyperledger/fabric/protos/peer"
)

type ProductContract struct {
}

type Product struct {
	ID    string `json:"ID"`
	Name   string `json:"name"`
	Address  string `json:"address"`
	ProductionDate string `json:"productionDate"`
	ReceiptDate string `json:"receiptDate"`
	SalesMethod string `json:"salesMethod"`
	SalesAddress string `json:"salesAddress"`
	Price string `json:"price"`
}

func (s *ProductContract) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	return shim.Success(nil)
}

func (s *ProductContract) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {

	// Retrieve the requested Smart Contract function and arguments
	function, args := APIstub.GetFunctionAndParameters()
	// Route to the appropriate handler function to interact with the ledger appropriately
	if function == "queryProduct" {
		return s.queryProduct(APIstub, args)
	} else if function == "addOrg1Info" {
		return s.addOrg1Info(APIstub, args)
	} else if function == "addOrg3Info" {
		return s.addOrg3Info(APIstub, args)
	} else if function == "addOrg4Info" {
		return s.addOrg4Info(APIstub, args)
	}

	return shim.Error("Invalid Smart Contract function name.")
}

func (s *ProductContract) queryProduct(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	productAsBytes, err := APIstub.GetState(args[0])
	if err != nil {
		return shim.Error("Failed to get product: " + err.Error())
	} else if productAsBytes == nil {
		fmt.Println("This product does not exist: " + args[0])
		return shim.Error("This product does not exist: " + args[0])
	}

	return shim.Success(productAsBytes)
}

func (s *ProductContract) addOrg1Info(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 4 {
		return shim.Error("Incorrect number of arguments. Expecting 5")
	}

	defer func(){
		if err:=recover();err!=nil{
			fmt.Println(err)
		}
	}()

	id, err := cid.New(APIstub)
	fmt.Println(id)
	if err != nil {
		return shim.Error("Failed to get client id: " + err.Error())
	}
	mspid, err := id.GetMSPID()
	if err != nil {
		return shim.Error("Failed to get mspid: " + err.Error())
	}
	fmt.Println(mspid)

	if mspid != "Org1MSP" {
		return shim.Error("Mspid Permission denied: " + mspid)
	}

	var product = Product{ID: args[0], Name: args[1], Address: args[2], ProductionDate: args[3]}

	productAsBytes, _ := json.Marshal(product)

	APIstub.PutState(args[0], productAsBytes)

	return shim.Success(nil)
}

func (s *ProductContract) addOrg3Info(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 4 {
		return shim.Error("Incorrect number of arguments. Expecting 4")
	}

	defer func(){
		if err:=recover();err!=nil{
			fmt.Println(err)
		}
	}()

	id, err := cid.New(APIstub)
	fmt.Println(id)
	if err != nil {
		return shim.Error("Failed to get client id: " + err.Error())
	}
	mspid, err := id.GetMSPID()
	if err != nil {
		return shim.Error("Failed to get mspid: " + err.Error())
	}
	fmt.Println(mspid)

	if mspid != "Org3MSP" {
		return shim.Error("Mspid Permission denied: " + mspid)
	}

	productAsBytes, err := APIstub.GetState(args[0])
	if err != nil {
		return shim.Error("Failed to get product: " + err.Error())
	} else if productAsBytes == nil {
		fmt.Println("This product does not exist: " + args[0])
		return shim.Error("This product does not exist: " + args[0])
	}

	product := Product{}

	json.Unmarshal(productAsBytes, &product)
	product.ReceiptDate = args[1]
	product.SalesMethod = args[2]
	product.SalesAddress = args[3]

	productAsBytes, _ = json.Marshal(product)
	APIstub.PutState(args[0], productAsBytes)

	return shim.Success(nil)
}

func (s *ProductContract) addOrg4Info(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	defer func(){
		if err:=recover();err!=nil{
			fmt.Println(err)
		}
	}()

	id, err := cid.New(APIstub)
	fmt.Println(id)
	if err != nil {
		return shim.Error("Failed to get client id: " + err.Error())
	}
	mspid, err := id.GetMSPID()
	if err != nil {
		return shim.Error("Failed to get mspid: " + err.Error())
	}
	fmt.Println(mspid)

	if mspid != "Org4MSP" {
		return shim.Error("Mspid Permission denied: " + mspid)
	}

	productAsBytes, err := APIstub.GetState(args[0])
	if err != nil {
		return shim.Error("Failed to get product: " + err.Error())
	} else if productAsBytes == nil {
		fmt.Println("This product does not exist: " + args[0])
		return shim.Error("This product does not exist: " + args[0])
	}

	product := Product{}

	json.Unmarshal(productAsBytes, &product)
	product.Price = args[1]

	productAsBytes, _ = json.Marshal(product)
	APIstub.PutState(args[0], productAsBytes)

	return shim.Success(nil)
}

func main() {

	// Create a new Smart Contract
	err := shim.Start(new(ProductContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
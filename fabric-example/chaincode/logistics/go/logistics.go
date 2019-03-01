package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/core/chaincode/shim/ext/cid"
	sc "github.com/hyperledger/fabric/protos/peer"
)

type LogisticsContract struct {
}

type Logistics struct {
	ID    string `json:"ID"`
	//Name   string `json:"name"`
	Company  string `json:"company"`
	ReceivingTime string `json:"receivingTime"`
	ArrivalTime string `json:"arrivalTime"`
	Sender string `json:"sender"`
	Recipient string `json:"recipient"`
	TransportPeriod string `json:"transportPeriod"`
}

func (s *LogisticsContract) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	return shim.Success(nil)
}

func (s *LogisticsContract) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {

	// Retrieve the requested Smart Contract function and arguments
	function, args := APIstub.GetFunctionAndParameters()
	// Route to the appropriate handler function to interact with the ledger appropriately
	if function == "queryProduct" {
		return s.queryProduct(APIstub, args)
	} else if function == "addOrg2Info" {
		return s.addOrg2Info(APIstub, args)
	}

	return shim.Error("Invalid Smart Contract function name.")
}

func (s *LogisticsContract) queryProduct(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

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

func (s *LogisticsContract) addOrg2Info(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 7 {
		return shim.Error("Incorrect number of arguments. Expecting 7")
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

	if mspid != "Org2MSP" {
		return shim.Error("Mspid Permission denied: " + mspid)
	}

	var logistics = Logistics{ID: args[0], Company: args[1], ReceivingTime: args[2], ArrivalTime: args[3], Sender: args[4], Recipient: args[5], TransportPeriod: args[6]}

	logisticsAsBytes, _ := json.Marshal(logistics)

	APIstub.PutState(args[0], logisticsAsBytes)

	return shim.Success(nil)
}

func main() {

	// Create a new Smart Contract
	err := shim.Start(new(LogisticsContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
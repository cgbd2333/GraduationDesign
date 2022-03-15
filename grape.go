package main

import(
	"encoding/json"
	"fmt"
	"log"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type SmartContract struct{
	contractapi.Contract
}

type Asset struct {
	ID 		string `json:"ID"`
	Owner	string `json:"owner"`
	Value	int    `json:"Value"`
}

func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	assets := []Asset{
		{ID:"asset1",Owner:"zhangsan",Value:300},
		{ID:"asset2",Owner:"LiSi",Value:400},
		{ID:"asset3",Owner:"Klay",Value:500},
	}

	for _,asset := range assets {
		assetJSON,err := json.Marshal(asset)
		if err !=nil {
			return err
		}

		err=ctx.GetStub().PutState(asset.ID,assetJSON)
		if err != nil {
			return fmt.Errorf("failed to put to world state. %v",err)
		}
	}

	return nil
}

func (s *SmartContract) ReadAsset(ctx contractapi.TransactionContextInterface,id string) (*Asset,error) {
	assetJSON,err := ctx.GetStub().GetState(id)
	if err != nil{
		return nil ,fmt.Errorf("failed to read from world state: %v",err)
	}
	if assetJSON == nil {
		return nil,fmt.Errorf("the asset %s does not exist",id)
	}

	var asset Asset
	err=json.Unmarshal(assetJSON , &asset)
	if err != nil{
		return nil,err
	}

	return &asset,nil
}

func (s *SmartContract) GetALLAssets(ctx contractapi.TransactionContextInterface) ([]*Asset,error){
	resultsIterator,err := ctx.GetStub().GetStateByRange("","")
	if err != nil {
		return nil,err
	}
	defer resultsIterator.Close()

	var assets []*Asset
	for resultsIterator.HasNext(){
		queryResponse,err:=resultsIterator.Next()
		if err !=nil{
			return nil,err
		}

		var asset Asset
		err=json.Unmarshal(queryResponse.Value, &asset)
		if err!=nil{
			return nil,err
		}
		assets=append(assets,&asset)
	}

	return assets,nil
}

func main(){
	assetChaincode,err := contractapi.NewChaincode(&SmartContract{})
	if err != nil{
		log.Panicf("Error creating asset-transfer-basic chaincode: %v",err)
	}

	if err:= assetChaincode.Start();err!=nil{
		log.Panicf("Error starting asser-transfer-basic chaincode: %v",err)
	}
}

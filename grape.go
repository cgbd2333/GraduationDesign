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

type Tel struct {
	TEL		string `json:"TEL"`
}

type Grape struct {
	Batch 	 	 string		`json:"Batch"`		//批次
	Producer 	 string		`json:"Producer"`	//生产者
	Tel			 Tel		`json:"Tel"`
	Temperature	 float32	`json:"Temperature"`//温度
	PH		 	 float32	`json:"PH"`			//PH值
}

func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	grapes := []Grape{
		{Batch: "20220315-1",Producer: "ZhangSan",Tel:Tel{TEL:"123456"},Temperature: 20.0,PH: 6.0},
		{
			Batch: "20220315-2",
			Producer: "LiSi",
			Tel: Tel{TEL:"123457"},
			Temperature: 21.2,
			PH: 5.0,
		},
		{
			Batch: "20220316-1",
			Producer: "WangWu",
			Tel: Tel{TEL:"123458"},
			Temperature: 22.0,
			PH: 5.8,
		},
	}

	for _,grape := range grapes {
		grapeJSON,err := json.Marshal(grape)
		if err !=nil {
			return err
		}

		err=ctx.GetStub().PutState(grape.Batch,grapeJSON)
		if err != nil {
			return fmt.Errorf("failed to put to world state. %v",err)
		}
	}

	return nil
}

func (s *SmartContract) QuaryGrape(ctx contractapi.TransactionContextInterface,batch string) (*Grape,error) {
	grapeJSON,err := ctx.GetStub().GetState(batch)
	if err != nil{
		return nil ,fmt.Errorf("failed to read from world state: %v",err)
	}
	if grapeJSON == nil {
		return nil,fmt.Errorf("the grape %s does not exist",batch)
	}

	var grape Grape
	err=json.Unmarshal(grapeJSON , &grape)
	if err != nil{
		return nil,err
	}
	
	return &grape,nil
}

func (s *SmartContract) QuaryAllGrapes(ctx contractapi.TransactionContextInterface) ([]*Grape,error){
	resultsIterator,err := ctx.GetStub().GetStateByRange("","")
	if err != nil {
		return nil,err
	}
	defer resultsIterator.Close()

	var grapes []*Grape
	for resultsIterator.HasNext(){
		queryResponse,err:=resultsIterator.Next()
		if err !=nil{
			return nil,err
		}

		var grape Grape
		err=json.Unmarshal(queryResponse.Value, &grape)
		if err!=nil{
			return nil,err
		}
		grapes=append(grapes,&grape)
	}

	return grapes,nil
}

func (s *SmartContract) AddGrape(ctx contractapi.TransactionContextInterface,batch string, producer string, temperature float32, ph float32) error {
	grape := Grape{
			batch,
			producer,
			Tel{""},
			temperature,
			ph,
	}
	grapeJSON,_ := json.Marshal(grape)

	return ctx.GetStub().PutState(batch,grapeJSON)
}

func (s *SmartContract) ChangeProducer(ctx contractapi.TransactionContextInterface, batch string, newProducer string) error {
	grape,err:= s.QuaryGrape(ctx,batch)

	if err != nil {
		return err
	}

	grape.Producer=newProducer

	grapeJSON,_ :=json.Marshal(grape)
	return ctx.GetStub().PutState(batch,grapeJSON)
}

func (s *SmartContract) ChangeTel(ctx contractapi.TransactionContextInterface, batch string, newTel string) error {
	grape,err:= s.QuaryGrape(ctx,batch)

	if err != nil {
		return err
	}

	grape.Tel.TEL=newTel

	grapeJSON,_ :=json.Marshal(grape)
	return ctx.GetStub().PutState(batch,grapeJSON)
}

func main(){
	grapeChaincode,err := contractapi.NewChaincode(&SmartContract{})
	if err != nil{
		log.Panicf("Error creating grape-transfer-basic chaincode: %v",err)
	}

	if err:= grapeChaincode.Start();err!=nil{
		log.Panicf("Error starting grape-transfer-basic chaincode: %v",err)
	}
}

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

type Producer struct {
	Name		 string 	`json:"Name"`		//种植方姓名
	Tel			 string 	`json:"Tel"`		//种植方电话
	Temperature	 float32	`json:"Temperature"`//大棚温度
	PH		 	 float32	`json:"PH"`			//土壤PH值
	Time		 string		`json:"Time`		//采摘时间
}

type Transporter struct {
	Name		string		`json:"Name"`		//运输司机姓名
	Tel			string 		`json:"Tel"`		//司机电话
	CarNum		string		`json:"CarNum"`		//车牌号
	StartAddress string		`json:"StartAddress"`//出发地
	StartTime	string		`json:"StartTime"`	//出发时间
	EndAddress	string		`json:"EndAddress"`//目的地
	EndTime		string		`json:"EndTime"`	//到达时间
}

type Sale struct {
	Name		string		`json:"Name"`		//销售员姓名
	Time		string		`json:"Time"`		//售卖时间
}

type Grape struct {
	Batch 	 	 string		`json:"Batch"`		//批次
	Producer	 Producer	`json:"Producer"`	//生产
	Transporter  Transporter `json:"Transporter"`//运输
	Sale		 Sale		`json:"Sale"`		//售卖
}

func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	grapes := []Grape{
		{
			Batch: "1",
			Producer: Producer {
				Name: "ZhangSan",
				Tel: "123456",
				Temperature: 22.0,
				PH: 5.0,
				Time: "20220321"},
			Transporter: Transporter {
				Name: "LiSi",
				Tel: "321654",
				CarNum: "2564",
				StartAddress: "ChangSha,HuNan",
				StartTime: "20220321",
				EndAddress: "WuHan,HuBei",
				EndTime: "20220322"},
			Sale: Sale {
				Name: "WangWu",
				Time: "20220323"},
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
/*
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
*/
/*
func (s *SmartContract) ChangeProducer(ctx contractapi.TransactionContextInterface, batch string, newProducer string) error {
	grape,err:= s.QuaryGrape(ctx,batch)

	if err != nil {
		return err
	}

	grape.Producer=newProducer

	grapeJSON,_ :=json.Marshal(grape)
	return ctx.GetStub().PutState(batch,grapeJSON)
}
*/
/*
func (s *SmartContract) ChangeTel(ctx contractapi.TransactionContextInterface, batch string, newTel string) error {
	grape,err:= s.QuaryGrape(ctx,batch)

	if err != nil {
		return err
	}

	grape.Tel.TEL=newTel

	grapeJSON,_ :=json.Marshal(grape)
	return ctx.GetStub().PutState(batch,grapeJSON)
}
*/
func main(){
	grapeChaincode,err := contractapi.NewChaincode(&SmartContract{})
	if err != nil{
		log.Panicf("Error creating grape-transfer-basic chaincode: %v",err)
	}

	if err:= grapeChaincode.Start();err!=nil{
		log.Panicf("Error starting grape-transfer-basic chaincode: %v",err)
	}
}

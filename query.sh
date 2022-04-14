 #! /bin/bash

PWD='/opt/fabric-2.3.0/scripts/fabric-samples/test-network'
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrg\
anizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrg\
anizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

query() {
	str=$1

	args=$(jq \
	-n --arg val "$str" \
'{"Args":["QuaryGrape",$val]}'
	)

	#echo $args

	peer chaincode query \
    -C mychannel \
    -n grape \
    -c "$args"
}

query "$1"

#query "$1" >out.json

#cd /home/hong/qrcode

#go run qrcode.go

#! /bin/bash

PWD='/opt/fabric-2.3.0/scripts/fabric-samples/test-network'
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerO\
rganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrgani\
zations/org2.example.com/users/Admin@org2.example.com/msp

peer chaincode query -C mychannel -n grape -c '{"Args":["QuaryAllGrapes"]}' #>out.json

#cd /home/hong/qrcode

#go run qrcode.go

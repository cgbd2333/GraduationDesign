#! /bin/bash

cd /opt/fabric-2.3.0/scripts/fabric-samples/test-network

PWD='/opt/fabric-2.3.0/scripts/fabric-samples/test-network'
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

peer lifecycle chaincode install grape.tar.gz 

id1=$(cat grapeid.txt)
id2=${id1##*:}
id3=""grape_1:"$id2"

cafile=/opt/fabric-2.3.0/scripts/fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
grape_id=$id3

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $cafile  --channelID mychannel --name grape --version 1.0 --package-id $grape_id Label: grape_1 --sequence 1

peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name grape --version 1.0 --sequence 1 --output json
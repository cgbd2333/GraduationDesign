#! /bin/bash

cafile=/opt/fabric-2.3.0/scripts/fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

org1_CertFiles=/opt/fabric-2.3.0/scripts/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt 

org2_CertFiles=/opt/fabric-2.3.0/scripts/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

peer lifecycle chaincode commit  -o localhost:7050  --ordererTLSHostnameOverride orderer.example.com  --tls --cafile $cafile --channelID mychannel --name grape --peerAddresses localhost:7051 --tlsRootCertFiles $org1_CertFiles --peerAddresses localhost:9051 --tlsRootCertFiles $org2_CertFiles --version 1.0 --sequence 1

peer chaincode invoke -o orderer.example.com:7050 --tls true --cafile $cafile -C mychannel -n grape --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles $org1_CertFiles --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles $org2_CertFiles -c '{"Args":["InitLedger"]}'

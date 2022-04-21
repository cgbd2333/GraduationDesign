#! /bin/bash

PWD='/opt/fabric-2.3.0/scripts/fabric-samples/test-network'
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOr\
ganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrgani\
zations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051


cafile=/opt/fabric-2.3.0/scripts/fabric-samples/test-network/org\
anizations/ordererOrganizations/example.com/orderers/orderer.exam\
ple.com/msp/tlscacerts/tlsca.example.com-cert.pem


org1_CertFiles=/opt/fabric-2.3.0/scripts/fabric-samples/tes\
t-network/organizations/peerOrganizations/org1.example.com/p\
eers/peer0.org1.example.com/tls/ca.crt 

org2_CertFiles=/opt/fabric-2.3.0/scripts/fabric-samples/tes\
t-network/organizations/peerOrganizations/org2.example.com/p\
eers/peer0.org2.example.com/tls/ca.crt

org3_CertFiles=/opt/fabric-2.3.0/scripts/fabric-samples/tes\
t-network/organizations/peerOrganizations/org3.example.com/p\
eers/peer0.org3.example.com/tls/ca.crt

peer lifecycle chaincode commit  \
-o localhost:7050  \
--ordererTLSHostnameOverride orderer.example.com  \
--tls \
--cafile $cafile \
--channelID mychannel \
--name grape \
--peerAddresses localhost:7051 \
--tlsRootCertFiles $org1_CertFiles \
--peerAddresses localhost:9051 \
--tlsRootCertFiles $org2_CertFiles \
--peerAddresses localhost:11051 \
--tlsRootCertFiles $org3_CertFiles \
--version 1.0 \
--sequence 1
if [ $? -eq 0 ]; then
     echo "链码提交成功"
else
     echo "链码提交失败"
	exit 1
fi

peer chaincode invoke \
-o orderer.example.com:7050 \
--tls true \
--cafile $cafile \
-C mychannel \
-n grape \
--peerAddresses peer0.org1.example.com:7051 \
--tlsRootCertFiles $org1_CertFiles \
--peerAddresses peer0.org2.example.com:9051 \
--tlsRootCertFiles $org2_CertFiles \
--peerAddresses peer0.org3.example.com:11051 \
--tlsRootCertFiles $org3_CertFiles \
-c '{"Args":["InitLedger"]}'
if [ $? -eq 0 ]; then
     echo "链码初始化成功"
else
     echo "链码初始化失败"
	exit 1
fi

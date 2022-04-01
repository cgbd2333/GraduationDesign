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

./network.sh down
./network.sh up createChannel
if [ $? -eq 0 ]; then
     echo "链码启动成功"
else
     echo "链码启动失败"
	   exit 1
fi

peer lifecycle chaincode package grape.tar.gz \
--path /home/hong/grape `# grape.go所在的文件路径`\
--lang golang \
--label grape_1
if [ $? -eq 0 ]; then
     echo "打包完成"
else
     echo "打包失败"
	   exit 1
fi

peer lifecycle chaincode install grape.tar.gz &> grapeid.txt

if [ $? -eq 0 ]; then
     echo "安装成功"
else
     echo "安装失败"
	   cat grapeid.txt
	   exit 1
fi

cat grapeid.txt

id1=$(cat grapeid.txt)
id2=${id1##*:}
id3=""grape_1:"$id2"



cafile=/opt/fabric-2.3.0/scripts/fabric-samples/test-network/org\
anizations/ordererOrganizations/example.com/orderers/orderer.exam\
ple.com/msp/tlscacerts/tlsca.example.com-cert.pem
grape_id=$id3

peer lifecycle chaincode approveformyorg -o localhost:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls \
--cafile $cafile \
--channelID mychannel \
--name grape \
--version 1.0 \
--package-id $grape_id Label: grape_1 \
--sequence 1

if [ $? -eq 0 ]; then
     echo "背书成功"
else
     echo "背书失败"
	   exit 1
fi

peer lifecycle chaincode checkcommitreadiness \
--channelID mychannel \
--name grape \
--version 1.0 \
--sequence 1 \
--output json


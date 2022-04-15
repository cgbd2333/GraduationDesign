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

cafile=/opt/fabric-2.3.0/scripts/fabric-samples/test-network/organ\
izations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
org1_CertFiles=/opt/fabric-2.3.0/scripts/fabric-samples/test-network/org\
anizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt 
org2_CertFiles=/opt/fabric-2.3.0/scripts/fabric-samples/test-network/org\
anizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

Insert() {
	arg1=$1
	arg2=$2
	arg3=$3


	args=$(jq \
	-n --arg val1 "$arg1" \
	-n --arg val2 "$arg2" \
	-n --arg val3 "$arg3" \
'{"Args":["AddSale",$val1,$val2,$val3]}'
	)

	#echo $args


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
    -c "$args"
}

Insert "$1" "$2" "$3"


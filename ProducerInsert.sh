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

cafile=/opt/fabric-2.3.0/scripts/fabric-samples/test-network/org\
anizations/ordererOrganizations/example.com/orderers/orderer.exam\
ple.com/msp/tlscacerts/tlsca.example.com-cert.pem

org1_CertFiles=/opt/fabric-2.3.0/scripts/fabric-samples/test-netw\
ork/organizations/peerOrganizations/org1.example.com/peers/peer0.o\
rg1.example.com/tls/ca.crt 

org2_CertFiles=/opt/fabric-2.3.0/scripts/fabric-samples/test-netw\
ork/organizations/peerOrganizations/org2.example.com/peers/peer0.o\
rg2.example.com/tls/ca.crt

org3_CertFiles=/opt/fabric-2.3.0/scripts/fabric-samples/test-netw\
ork/organizations/peerOrganizations/org3.example.com/peers/peer0.o\
rg3.example.com/tls/ca.crt

Insert() {
	arg1=$1
	arg2=$2
	arg3=$3
	arg4=$4
	arg5=$5
	arg6=$6

	args=$(jq \
	-n --arg val1 "$arg1" \
	-n --arg val2 "$arg2" \
	-n --arg val3 "$arg3" \
	-n --arg val4 "$arg4" \
	-n --arg val5 "$arg5" \
	-n --arg val6 "$arg6" \
	'{"Args":["AddProducer",$val1,$val2,$val3,$val4,$val5,$val6]}'
	)

	#echo $args

	if [ ${CORE_PEER_ADDRESS} == "localhost:7051" ] 
	then
		peer chaincode invoke \
		-o orderer.example.com:7050 \
		--tls true --cafile $cafile \
		-C mychannel \
		-n grape \
		--peerAddresses peer0.org1.example.com:7051 \
		--tlsRootCertFiles $org1_CertFiles \
		--peerAddresses peer0.org2.example.com:9051 \
		--tlsRootCertFiles $org2_CertFiles \
		--peerAddresses peer0.org3.example.com:11051 \
		--tlsRootCertFiles $org3_CertFiles \
		-c "$args"
	else
		echo "您没有足够的权限"
	fi

}

Insert "$1" "$2" "$3" "$4" "$5" "$6"

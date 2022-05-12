# 毕业设计-葡萄溯源系统

## Go文件

### grape.go
智能合约

### qrcode.go
生成追溯二维码

## 链码启动
### org1.sh
生产组织上链。用法：
./org1.sh

### org2.sh
物流组织上链。用法：
./org2.sh

### org3.sh
销售组织上链。用法：
./org3.sh

### commit.sh
提交链码。用法：
./commit.sh

## 数据上传

### ProducerInsert.sh   
生产组织（org1）上传数据。用法：
./ProducerInsert.sh  3 cgbd 1222222 22.3 4.9 20220325

该葡萄批次编号为3，种植方姓名为cgbd，种植方电话为1222222，温室大棚温度为22.3℃，土壤PH值为4.9，采摘日期为20220325

### TransporterInsert.sh
物流组织（org2）上传数据。用法：
./TransporterInsert.sh 3 Tom 133333 5825 Changde 20220401 changsha 20220402

批次为3，负责人为Tom，联系电话为133333，车牌号5825，出发地为Changde，出发时间为20220401，目的地为changsha，到达时间为20220402

### SaleInset.sh
销售组织上传数据。用法：
./SaleInsert.sh 3 Jerry 20220403

批次为3，销售负责人为Jerry，销售时间为20220403 


## 信息查询

### query.sh queryall.sh
生产组织查询。

./query.sh 1 查询批次为1的葡萄信息

./queryall.sh 查询所有葡萄信息

### org2_query.sh org2_queryall.sh
物流组织查询。

./org2_query.sh 1 查询批次为1的葡萄信息

./org2_queryall.sh 查询所有葡萄信息

### org3_query.sh org3_queryall.sh
物流组织查询。

./org3_query.sh 1 查询批次为1的葡萄信息

./org3_queryall.sh 查询所有葡萄信息

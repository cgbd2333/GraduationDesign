package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"bytes"
	"github.com/skip2/go-qrcode"
)
 
func main() {
    b, err := ioutil.ReadFile("/opt/fabric-2.3.0/scripts/fabric-samples/test-network/out.json") 
    if err != nil {
        fmt.Print(err)
    } 
	var out bytes.Buffer
	json.Indent(&out, []byte(b), "", "    ") 
	str:=out.String()
	qrcode.WriteFile(str,qrcode.Medium,256,"../Desktop/1.png")

}

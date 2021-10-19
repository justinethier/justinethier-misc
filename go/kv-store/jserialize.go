package main

import (
    "encoding/json"
    "fmt"
    "io/ioutil"
    "os"
)

type Log struct {
  Key string
  Data []byte
  ContentType string
  Deleted bool
}

type Rankings struct {
    Keyword  string
    GetCount uint32
    Engine   string
    Locale   string
    Mobile   bool
}

func main() {
    var jsonBlob = []byte(`
        {"keyword":"hipaa compliance form", "get_count":157, "engine":"google", "locale":"en-us", "mobile":false}
    `)
    rankings := Rankings{}
    err := json.Unmarshal(jsonBlob, &rankings)
    if err != nil {
        // nozzle.printError("opening config file", err.Error())
    }

    rankingsJson, _ := json.Marshal(rankings)
    err = ioutil.WriteFile("output.json", rankingsJson, 0644)
    fmt.Printf("%+v", rankings)


    logA := Log { Key: "test", Data: []byte{0, 0, 0, 1, 2}, ContentType: "text", Deleted: false }
    logB := Log { Key: "test b", Data: []byte("test"), ContentType: "text", Deleted: false }
    logs := []Log { logA, logB }

    //fmt.Println(logs)
    b, err := json.Marshal(logs)
    if err != nil {
      fmt.Println("error", err)
      return
    }

    f, err :=  os.Create("tmp.json")
    if err != nil {
      fmt.Println("error", err)
      return
    }
    f.Write(b)
    f.Close()

    //f, err := os.Open("tmp.json")
    plan, _ := ioutil.ReadFile("tmp.json")
    var data []Log
    err = json.Unmarshal(plan, &data)
    //f.Close()
    fmt.Println("")
    fmt.Println("data", data)
}


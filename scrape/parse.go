package main

import (
  "encoding/json"
  "fmt"
  "io/ioutil"
  "os"
)

func readFile(filename string) []byte {
  // Open our jsonFile
  jsonFile, err := os.Open(filename)
  // if we os.Open returns an error then handle it
  if err != nil {
      fmt.Println(err)
  }
  fmt.Println("Successfully Opened", filename)
  // defer the closing of our jsonFile so that we can parse it later on
  defer jsonFile.Close()

  byteValue, _ := ioutil.ReadAll(jsonFile)
  return byteValue
}

type Result struct {
  Data Data `json:"data"`
  Error bool `json:"error"`
  Status int `json:"status"`
}

type Data struct {
   Links Links `json:"_links"`
   Ranks []Rank `json:"ranks"`
}

type Links struct {
  First string `json:"first"`
  Last string `json:"last"`
  Next string `json:"next"`
}

type Rank struct {
  ID int `json:"id"`
  Name string `json:"name"`
  NumGames int `json:"nbgames"`
  Karma int `json:"karma"`
  Score int `json:"score"`
  Rank int `json:"rank"`
  LastGame int `json:"lastgame"`
}

func main() {
  bv := readFile("sample.json")
  var result Result

  json.Unmarshal(bv, &result)
  fmt.Printf("%v %v %v\n", result.Data, result.Error, result.Status)

// TODO:
//   // we iterate through every user within our users array and
//    // print out the user Type, their name, and their facebook url
//    // as just an example
//    for i := 0; i < len(users.Users); i++ {
//        fmt.Println("User Type: " + users.Users[i].Type)
//        fmt.Println("User Age: " + strconv.Itoa(users.Users[i].Age))
//        fmt.Println("User Name: " + users.Users[i].Name)
//        fmt.Println("Facebook Url: " + users.Users[i].Social.Facebook)
//    }
}

package main

import (
  "encoding/json"
  "fmt"
  "io/ioutil"
  "net/http"
  "os"
  "log"

  "database/sql"
  _ "github.com/mattn/go-sqlite3"
 // "github.com/PuerkitoBio/goquery"
)

func getListing(listingURL string) []byte {
  response, err := http.Get(listingURL)
  if err != nil {
    fmt.Println(err)
  }
  defer response.Body.Close()
  if response.StatusCode == 200 {
    bodyText, err := ioutil.ReadAll(response.Body)
    if err != nil {
      fmt.Println(err)
    }
    //fmt.Printf("%s\n", bodyText)
    return bodyText
  }

  return []byte{}
}

//func getListing2(listingURL string) []string {
//  var links []string
//  // HTTP client with timeout
//  client := &http.Client {
//    Timeout: 30 * time.Second,
//  }
//  request, err := http.NewRequest("GET", listingURL, nil)
//  if err != nil {
//    fmt.Println(err)
//  }
//
//  // Setting headers
//  request.Header.Set("pragma", "no-cache")
//  request.Header.Set("cache-control", "no-cache")
//  request.Header.Set("dnt", "1")
//  request.Header.Set("upgrade-insecure-requests", "1")
//  request.Header.Set("referer", "https://www.yelp.com/")
//  resp, err := client.Do(request)
//
//  if resp.StatusCode == 200 {
//    doc, err := goquery.NewDocumentFromReader(resp.Body)
//    if err != nil {
//      fmt.Println(err)
//    }
//    doc.Find(".lemon--ul__373c0__1_cxs a").Each(func(i int, s *goquery.Selection) {
//      link, _ := s.Attr("href")
//      link = "https://www.yelp.com/" + link
//
//      // Make sure we only fetch correct url with title
//      if strings.Contains(link, "biz/") {
//        text := s.Text()
//        if text != "" && text != "more" { // avoid unnecessary links
//          //
//          links = append(links, link)
//        }
//      }
//    })
//  }
//
//  return links
//}

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

func ParseFile() {
  bv := readFile("sample.json")
  Parse(bv)
}

func insert(db *sql.DB, name string, rank int) {
	_, err := db.Exec("insert into ranks(name, rank) values(?, ?)", name, rank)
	if err != nil {
		log.Fatal(err)
	}
}

func Parse(bv []byte) {
  var result Result

  json.Unmarshal(bv, &result)
  fmt.Printf("%v %v %v\n", result.Data, result.Error, result.Status)

	db, err := sql.Open("sqlite3", "./foo.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

  for i := 0; i < len(result.Data.Ranks); i++ {
    row := result.Data.Ranks[i]
    fmt.Printf("%3d - %s - %d - %d\n", row.Rank, row.Name, row.Score, row.NumGames)
    insert(db, row.Name, row.Rank)
  }
}

func main() {
  body := getListing("https://account.asmodee.net/en/prx/rankings/Carcassonne/established?limit=10&offset=0")
  Parse(body)

}

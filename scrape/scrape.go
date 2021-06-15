package main

import (
  "encoding/json"
  "fmt"
  "io/ioutil"
  "net/http"
  "strings"
  "time"

  "github.com/PuerkitoBio/goquery"
)

func getListing(listingURL string) {
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

  return ""
}

func getListing2(listingURL string) []string {
  var links []string
  // HTTP client with timeout
  client := &http.Client {
    Timeout: 30 * time.Second,
  }
  request, err := http.NewRequest("GET", listingURL, nil)
  if err != nil {
    fmt.Println(err)
  }

  // Setting headers
  request.Header.Set("pragma", "no-cache")
  request.Header.Set("cache-control", "no-cache")
  request.Header.Set("dnt", "1")
  request.Header.Set("upgrade-insecure-requests", "1")
  request.Header.Set("referer", "https://www.yelp.com/")
  resp, err := client.Do(request)

  if resp.StatusCode == 200 {
    doc, err := goquery.NewDocumentFromReader(resp.Body)
    if err != nil {
      fmt.Println(err)
    }
    doc.Find(".lemon--ul__373c0__1_cxs a").Each(func(i int, s *goquery.Selection) {
      link, _ := s.Attr("href")
      link = "https://www.yelp.com/" + link

      // Make sure we only fetch correct url with title
      if strings.Contains(link, "biz/") {
        text := s.Text()
        if text != "" && text != "more" { // avoid unnecessary links
          //
          links = append(links, link)
        }
      }
    })
  }

  return links
}

func main() {
  //getListing("http://adnansiddiqi.me")
  //m := getListing2("https://www.yelp.com/search?cflt=mobilephonerepair&find_loc=San+Francisoco@2C+CA")
  //fmt.Println(strings.Join(m, "\n"))
  body := getListing("https://account.asmodee.net/en/prx/rankings/Carcassonne/established?limit=10&offset=0")
}

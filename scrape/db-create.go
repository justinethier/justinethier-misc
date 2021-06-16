package main

import (
  "database/sql"
  //"fmt"
  _ "github.com/mattn/go-sqlite3"
  "log"
  "os"
)

func main() {
  os.Remove("./foo.db")

  db, err := sql.Open("sqlite3", "./foo.db")
  if err != nil {
    log.Fatal(err)
  }
  defer db.Close()

  sqlStmt := `
  create table ranks (id integer not null primary key, 
                      account_id integer,
                      name text,
                      num_games int,
                      karma int,
                      score int,
                      rank int,
                      last_game int);
  delete from ranks;
  `
  _, err = db.Exec(sqlStmt)
  if err != nil {
    log.Printf("%q: %s\n", err, sqlStmt)
    return
  }

}

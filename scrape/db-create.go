package main

import (
  "database/sql"
  //"fmt"
  _ "github.com/mattn/go-sqlite3"
  "log"
  "os"
)

func main() {
  os.Remove("./rank-data.db")

  db, err := sql.Open("sqlite3", "./rank-data.db")
  if err != nil {
    log.Fatal(err)
  }
  defer db.Close()

  sqlStmt := `
  create table rank (id integer not null primary key, 
                      run_id integer,
                      account_id integer,
                      name text,
                      num_games int,
                      karma int,
                      score int,
                      rank int,
                      last_game int);
  delete from rank;
  `
  _, err = db.Exec(sqlStmt)
  if err != nil {
    log.Printf("%q: %s\n", err, sqlStmt)
    return
  }

  sqlStmt = `
  create table run (id integer not null primary key, 
                    collection_time text
                      );
  delete from run;
  `
  _, err = db.Exec(sqlStmt)
  if err != nil {
    log.Printf("%q: %s\n", err, sqlStmt)
    return
  }

}

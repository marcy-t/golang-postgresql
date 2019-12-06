package main

import (
  "app/db"
  "database/sql"

  "fmt"
  "net/http"
)

var (
  DB  *sql.DB
)

func hello(w http.ResponseWriter, r *http.Request) {

  fmt.Fprintf(w, "Hello, World")

  fmt.Println("----- End jobstate -----")
  //fmt.Println(rows)

  fmt.Fprint(w, "SelectJobStatus")
}


func handleRequests() {
  DB=db.Init()

  http.HandleFunc("/", hello)

  http.ListenAndServe(":8081", nil)
}

func main() {
  handleRequests()
}

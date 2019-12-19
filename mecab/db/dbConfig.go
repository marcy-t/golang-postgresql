package db

import (
//	"app/query"

	"database/sql"
	_ "github.com/lib/pq"
	"fmt"
	"log"
	"os"

	//	"time"
)

var (
	DB  *sql.DB
	err error
)

/*
type App struct {
	DB  *sql.DB
	err error
}
 */

func Init () *sql.DB{
	//Initialize db from the main function
	//HOST := "postgres-db"
	HOST := os.Getenv("POSTGRES_HOST")
	DATABASE := os.Getenv("POSTGRES_DB")
	USER     := os.Getenv("POSTGRES_USER")
	PASSWORD := os.Getenv("POSTGRES_PASSWORD")

	var connectionString string =
		fmt.Sprintf("host=%s user=%s password=%s dbname=%s sslmode=disable", HOST, USER, PASSWORD, DATABASE)

	DB, err = sql.Open("postgres", connectionString)
	if err != nil {
		log.Fatal("Error: The data source arguments are not valid")
	}

	err = DB.Ping()
	if err != nil {
		log.Fatal("Error: Could not establish a connection with the database")
	}
	fmt.Println("Successfully created connection to database")

	return DB
}


/*
func SesUpdateProcessing() string{
	//a:=query.SelectSQL(DB)
	sesUpProcess:=query.SelectJobState(DB)
	//fmt.Println(a)
	return sesUpProcess
}

 */

/*

func SesSegment() string{
	sesSegments:=query.SelectSegments(DB)
	//fmt.Println(sesJobSegments)
	return sesSegments
}

 */







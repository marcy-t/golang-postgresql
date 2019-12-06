package query
import (
	"database/sql"
	"fmt"
	"time"
)

/*
	3.ジョブステータス（SELECT UPDATE）
*/
type Jobs struct {
	// Table:Jobs
	JobsId                 int            `Jobs:Id`
	JobsName               string         `Jobs:Name`
	JobsGroup_id           int            `Jobs:Group_id`
	JobsUser_id            int            `Jobs:User_id`
	JobsCreate_at          time.Time      `Jobs:Create_at`
	JobsState              string         `Jobs:State`
	JobsAutoflg            bool           `Jobs:Autoflg`
	// Table:job_segments
	job_segmentsJob_id     int            `job_segments:Job_id`
	job_segmentsSegment_id int            `job_segments:Segment_id`
	job_segmentsSort       int            `job_segments:Sort`
}

//func (rep Jobs) SelectJobStatus(db *sql.DB) string{
func SelectJobState(db *sql.DB) string{

	// slice
	//jobsId := []interface{}

	query := `
		/*
			3.ジョブステータス（SES）
		*/
		WITH
		  jobs AS(
			SELECT
				jbs.id
			,   jbs.name 
			,   jbs.group_id
			,   jbs.user_id
			,   jbs.create_at
			,   jbs.state
			,   jbs.auto_flg
			,   jsg.job_id
			,   jsg.segment_id
			,   jsg.sort
			FROM
				jobs jbs
			,   job_segments jsg
			WHERE 1=1
			AND jbs.state='New'
			AND jbs.id=jsg.job_id
			ORDER BY jbs.create_at ASC
		) SELECT * FROM jobs;
	`

	rows , err := db.Query(query)
	if err != nil {
		fmt.Println(err)
	}
	defer rows.Close()



	for rows.Next() {
		rep:=Jobs{}
		rows.Scan(&rep.JobsId, &rep.JobsName, &rep.JobsGroup_id, &rep.JobsUser_id, &rep.JobsCreate_at, &rep.JobsState, &rep.JobsAutoflg, &rep.job_segmentsJob_id, &rep.job_segmentsSegment_id, &rep.job_segmentsSort)

		//fmt.Println(&rep.Id, rep.Id)
		//fmt.Println(rep.Name)
		//fmt.Println(&rep.State, rep.State)
		//fmt.Printf("%T", rep)


		//jobsId=append(jobsId, &rep.Id, &rep.Name)
		/*
			ここにVertic　Insert処理
		*/

		/***
		  Update to State　Processing
		*/

		/**
		DebugCode
		*/
		time.Sleep(2 * time.Second)
		UpdateJobState(db, rep.JobsId)
		fmt.Println(rep)

		/**
		DebugCode
		*/
		//time.Sleep(2 * time.Second)
		//UpdateJobDone(db, rep.JobsId)

	}



	jobState:="End UpdateJobStatus"

	return jobState

}



func UpdateJobState(db *sql.DB, upid int) int{
	query := `
		/*
			3.ジョブステータス（UPD）
		*/
		UPDATE jobs
		SET 
			state='Processing'
		WHERE 1=1
		AND id = $1
		AND state='New'
	`

	fmt.Println ("*** Start Job Status ***")

	tx, err := db.Begin()
	if err != nil {
		fmt.Println(err)
	}

	/***
	  Update
	*/
	_, err = db.Exec(query, upid)

	if err != nil {
		/***
		  Rollback
		*/
		tx.Rollback()
		fmt.Println(err)
	}

	/***
	  Commit
	*/
	tx.Commit()

	fmt.Println ("*** End Job Status ***")

	return upid
}

/*
	5.ジョブステータス（UPDATE）
*/
func UpdateJobDone(db *sql.DB, upid int) int{
	query := `
		/*
			5.ジョブステータス（UPD）
		*/
		UPDATE jobs
		SET 
			state='Done'
		,   job_finished_at=CURRENT_TIMESTAMP
		WHERE 1=1
		AND id = $1
		AND state='Processing'
	`

	fmt.Println ("*** Start Job Status End ***")

	tx, err := db.Begin()
	if err != nil {
		fmt.Println(err)
	}

	/***
	  Update
	*/
	_, err = db.Exec(query, upid)
	if err != nil {
		/***
		  Rollback
		*/
		tx.Rollback()
		fmt.Println(err)
	}

	/***
	  Commit
	*/
	tx.Commit()

	//defer db.Close()

	fmt.Println ("*** End Job Status End ***")

	return upid
}



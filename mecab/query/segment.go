package query

import (
	"database/sql"
	"fmt"
	"time"
)

/*
	6.セグメント（SELECT）
*/
type Segments struct {
	SegmentsId             int        `segments:Id`
	SegmentsName           string     `segments:Name`
	SegmentsGroup_id       int        `segments:group_id`
	SegmentsUser_id        int        `segments:user_id`
	SegmentsSex_id         int        `segments:sex_id`
	SegmentsAge_min        int        `segments:age_min`
	SegmentsAge_max        int        `segments:age_max`
	SegmentsDate_from      time.Time  `segments:date_from`
	SegmentsDate_to        time.Time  `segments:date_to`
	SegmentsBunrui_type_id int  `segments:bunrui_type_id`
	SegmentsPurchase_condition string  `segments:purchase_condition`
//	SegmentsMemo           string  `segments:memo`
	SegmentsSegment_id     int  `segments:segment_id`
	SegmentsJan            string  `segments:jan`
}

func SelectSegments(db *sql.DB) string {

	// slice
	/* ポインタ型　取り出しが面倒なので一旦残す
	JobSegmentsId:=[]*int{}
	JobSegSlice:=[][]*int{}
	 */

	query := `
WITH
  segment_all AS(
    SELECT
        seg.id
    ,   seg.name
    ,   seg.group_id
    ,   seg.user_id
    ,   seg.sex_id
    ,   seg.age_min
    ,   seg.age_max
    ,   seg.date_from
    ,   seg.date_to
    ,   seg.bunrui_type_id
    ,   seg.purchase_condition
--    ,   seg.memo
    ,   sgj.segment_id
    ,   sgj.jan
    FROM
        segments     seg
    ,   job_segments jsg
    ,   segment_jans sgj
    WHERE 1=1
    AND seg.id=jsg.segment_id
    AND jsg.segment_id=sgj.segment_id
    AND seg.id IN (1,2,3)
    ORDER BY seg.id ASC
) SELECT * FROM segment_all;
	`

	rows, err := db.Query(query)
	if err != nil {
		fmt.Println(err)
	}
	defer rows.Close()

	for rows.Next() {
		rep := Segments{}
		rows.Scan(&rep.SegmentsId, &rep.SegmentsName, &rep.SegmentsGroup_id, &rep.SegmentsUser_id, &rep.SegmentsSex_id, &rep.SegmentsAge_min, &rep.SegmentsAge_max, &rep.SegmentsDate_from, &rep.SegmentsDate_to, &rep.SegmentsBunrui_type_id, &rep.SegmentsPurchase_condition, &rep.SegmentsSegment_id, &rep.SegmentsJan)


		fmt.Println(rep)


		/*
			ここにVertic　Insert処理
		*/


	}



	SegmentState:="End SelectSegments"

	return SegmentState
}


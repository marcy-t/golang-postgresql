/**
CREATE TABLE IF NOT EXISTS sum_kaiin (
    id auto_increment PRIMARY KEY,
    create_at TIMESTAMP WITH TIME zone default current_timestamp,
    segment_id INTEGER REFERENCES segments(id),
    prefecture VARCHAR(20), 
    uu INTEGER 
);
*/
-- ---------------------------
-- sum_kaiin
-- ---------------------------
insert into sum_kaiin
(
    segment_id
,   prefecture
,   uu
)
-- ----------------------
with
-- ----------------------
-- ----------------------
base as (
select
	s.segment_id
	,d.KAIIN_NUM     AS kaiin_num
	,d.AREA01 AS prefecture
from BI.M_KAIIN d
inner join segment_ids s
on d.KAIIN_NUM = s.id
where 1=1
-- and s.segment_id = :segment_id
and s.segment_id = 1
-- and s.segment_id = 2
-- and s.segment_id = 3
-- and s.segment_id = 4
-- and s.segment_id = 5
-- and s.segment_id = 6
-- and s.segment_id = 7
-- and s.segment_id = 8
-- and s.segment_id = 9
-- and s.segment_id = 10
-- and s.segment_id = 11
-- and s.segment_id = 12
)
-- select * from base;
,
-- ----------------------
-- ----------------------
sum as (
	select
	     b.segment_id
		,b.prefecture
		,count(DISTINCT b.kaiin_num) as uu
	from base b
	group by
	b.segment_id
	,b.prefecture
)
-- select * from sum limit 10;
select * from sum;

-- ---------------------------
-- sum_tsutaya_music
-- ---------------------------
insert into sum_tsutaya_music
(
    segment_id
,   daibunrui_nm
,   daibunrui_cd
,   uu
,   uu_all
)
-- ----------------------
with
-- ----------------------
-- ----------------------
base as (
select
	s.segment_id
	,d.KAIIN_NUM     AS kaiin_num
	,j.DAI_BUNRUI    AS daibunrui_nm
	,j.DAI_BUNRUI_CD AS daibunrui_cd
from BI.TR_TSUTAYA d
inner join segment_ids s
on d.KAIIN_NUM = s.id
inner join BI.IM_TSUTAYA j
on d.SYOHIN_CD = j.SYOHIN_CD
and d.ITEM_CD = j.ITEM_CD
inner join BI.ART_TSUTAYA a
on d.SYOHIN_CD = a.SYOHIN_CD
and d.ITEM_CD = a.ITEM_CD
where 1=1
-- 購買期間:12ヶ月
and d.SIYO_DATE >= to_char(date_trunc('month', current_date -9) - '12 month'::intervalym,'YYYYMMDD')
and d.SIYO_DATE < to_char(date_trunc('month', current_date -9),'YYYYMMDD')
-- 商品
and j.CATEGORY_CD = '02'
and j.ITEM_MEI in ('01DVD', '01CDアルバム', '02CDシングル', '02ブルーレイ')
-- セグメント
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
uu_all as (
select
	segment_id 
	,count(*) as uu_all
	from segment_ids	
	group by segment_id
)
-- select * from uu_all order by segment_id;
,
-- ----------------------
-- ----------------------
sum as (
	select
	     b.segment_id
		,b.daibunrui_nm
		,b.daibunrui_cd
		,u.uu
		,count(DISTINCT b.kaiin_num) as uu_all
	from base b
	inner join uu_all u
	on b.segment_id = u.segment_id
	group by
	b.segment_id
	,b.daibunrui_nm
	,b.daibunrui_cd
	,u.uu_all
)
-- select * from sum limit 10;
select * from sum;

-- ---------------------------
-- sum_tsutaya_book_sku
-- ---------------------------
insert into sum_tsutaya_book_sku
(
    segment_id
,   daibunrui_nm
,   daibunrui_cd
,   chubunrui_nm
,   chubunrui_cd 
,   syohin_nm
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
	,j.CHU_BUNRUI    AS chubunrui_nm
	,j.CHU_BUNRUI_CD AS chubunrui_cd 
	,j.SYOHIN_MEI    AS syohin_nm
from BI.TR_TSUTAYA d
inner join segment_ids s
on d.KAIIN_NUM = s.id
inner join BI.IM_TSUTAYA j
on d.SYOHIN_CD = j.SYOHIN_CD
and d.ITEM_CD = j.ITEM_CD
where 1=1
-- 購買期間:12ヶ月
and d.SIYO_DATE >= to_char(date_trunc('month', current_date -9) - '12 month'::intervalym,'YYYYMMDD')
and d.SIYO_DATE < to_char(date_trunc('month', current_date -9),'YYYYMMDD')
-- 商品
and j.CATEGORY_CD = '02'
and j.ITEM_MEI in ('01雑誌', '02書籍', '03コミック')
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
	b.segment_id 
	,b.daibunrui_cd
	,b.chubunrui_cd 
	,count(distinct b.kaiin_num) as uu_all
	from base b
	group by 
	segment_id
	,b.daibunrui_cd
	,b.chubunrui_cd 
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
		,b.chubunrui_nm
		,b.chubunrui_cd 
		,b.syohin_nm
		,count(DISTINCT b.kaiin_num) as uu
		,u.uu_all
	from base b
	inner join uu_all u
	on b.segment_id = u.segment_id
	and b.daibunrui_cd = u.daibunrui_cd
	and b.chubunrui_cd = u.chubunrui_cd 
	group by
	b.segment_id
	,b.daibunrui_nm
	,b.daibunrui_cd
	,b.chubunrui_nm
	,b.chubunrui_cd 
	,b.syohin_nm
	,u.uu_all
)
-- select * from sum limit 10;
select * from sum;

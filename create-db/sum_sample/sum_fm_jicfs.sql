-- ---------------------------
-- sum_fm_jicfs
-- ---------------------------
insert into sum_fm_jicfs
(
    segment_id
,   daibunrui_nm
,   daibunrui_cd
,   chubunrui_nm
,   chubunrui_cd 
,   shobunrui_nm
,   shobunrui_cd
,   saibunrui_nm
,   saibunrui_cd
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
	,j.SHO_BUNRUI    AS shobunrui_nm
	,j.SHO_BUNRUI_CD AS shobunrui_cd
	,j.SAI_BUNRUI    AS saibunrui_nm
	,j.SAI_BUNRUI_CD AS saibunrui_cd
from BI.TR_DU d
inner join segment_ids s
on d.KAIIN_NUM = s.id
inner join BI.IM_JICFS j
on d.SYOHIN_CD = j.SYOHIN_CD
where 1=1
-- 購買期間:12ヶ月
and d.SIYO_DATE >= to_char(date_trunc('month', current_date -9) - '12 month'::intervalym,'YYYYMMDD')
and d.SIYO_DATE < to_char(date_trunc('month', current_date -9),'YYYYMMDD')
-- 商品
and (
	j.CHU_BUNRUI in ('140000_飲料・酒類', '130000_菓子類') 
	or j.SAI_BUNRUI in ('111203_カップ麺', '199701_たばこ')
)
-- and s.segment_id = :segment_id
--and s.segment_id = 1
--and s.segment_id = 2
--and s.segment_id = 3
--and s.segment_id = 4
--and s.segment_id = 5
--and s.segment_id = 6
--and s.segment_id = 7
--and s.segment_id = 8
--and s.segment_id = 9
--and s.segment_id = 10
--and s.segment_id = 11
and s.segment_id = 12
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
		,b.chubunrui_nm
		,b.chubunrui_cd 
		,b.shobunrui_nm
		,b.shobunrui_cd
		,b.saibunrui_nm
		,b.saibunrui_cd
		,count(DISTINCT b.kaiin_num) as uu
		,u.uu_all
	from base b
	inner join uu_all u
	on b.segment_id = u.segment_id
	group by
	b.segment_id
	,b.daibunrui_nm
	,b.daibunrui_cd
	,b.chubunrui_nm
	,b.chubunrui_cd 
	,b.shobunrui_nm
	,b.shobunrui_cd
	,b.saibunrui_nm
	,b.saibunrui_cd
	,u.uu_all
)
-- select * from sum limit 10;
select * from sum;
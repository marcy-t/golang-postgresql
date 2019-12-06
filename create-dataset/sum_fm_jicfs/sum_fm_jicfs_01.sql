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
,   uu_all
,   uu
)
with
seg_ids as (
select
	    segment_id as ID
	,   id         as KAIIN_NUM
	-- UU_ALL
	,count(*) over () as UU_ALL
	from segment_ids	
)
-- Debug --
/*
select 
    * 
from 
    seg_ids
order by ID asc 
;
*/
-- Debug --
,
-- ----------------------
-- 比較対象集計
-- and seg.ID = 1
-- and seg.ID = 2
-- ----------------------
sum as (
	select
	     seg.ID          AS segment_id
		,j.DAI_BUNRUI    AS daibunrui_nm
		,j.DAI_BUNRUI_CD AS daibunrui_cd
		,j.CHU_BUNRUI    AS chubunrui_nm
		,j.CHU_BUNRUI_CD AS chubunrui_cd 
		,j.SHO_BUNRUI    AS shobunrui_nm
		,j.SHO_BUNRUI_CD AS shobunrui_cd
		,j.SAI_BUNRUI    AS saibunrui_nm
		,j.SAI_BUNRUI_CD AS saibunrui_cd
		--,j.SYOHIN_MEI    AS syohin_nm
		,seg.UU_ALL      AS uu_all
		,count(DISTINCT seg.KAIIN_NUM) as uu
	--from BI.TR_TSUTAYA d
	from BI.TR_DU d
	inner join seg_ids seg
	on d.KAIIN_NUM = seg.KAIIN_NUM
	--inner join BI.IM_TSUTAYA j
	--on d.SYOHIN_CD = j.SYOHIN_CD
	--
	inner join BI.IM_JICFS j
	on d.SYOHIN_CD = j.SYOHIN_CD
	--
	--inner join BI.ART_TSUTAYA t
	--on t.SYOHIN_CD = j.SYOHIN_CD
	where 1=1
	-- 業態：CVS
	-- d.ALLIANCE_CD in ('9011','9025','9065','9051','9043','9088','9072')
	-- 購買期間:固定直近13ヶ月
	-- and d.SIYO_DATE >= to_char(date_trunc('month', current_date) - '13 month'::intervalym,'YYYYMMDD')
	and d.SIYO_DATE >= to_char(date_trunc('month', current_date) - '12 month'::intervalym,'YYYYMMDD')
	and d.SIYO_DATE < to_char(date_trunc('month', current_date),'YYYYMMDD')
	and seg.ID = 1
	--and seg.ID = 2
	--and seg.ID = 3
	--and seg.ID = 4
	--and seg.ID = 5
	--and seg.ID = 6
	--and seg.ID = 7
	--and seg.ID = 8
	--and seg.ID = 9 
	--and seg.ID = 10
	--and seg.ID = 11
	--and seg.ID = 12 
	group by
	seg.ID,
	j.DAI_BUNRUI,
	j.DAI_BUNRUI_CD,
	j.CHU_BUNRUI,
	j.CHU_BUNRUI_CD,
	j.SHO_BUNRUI,
	j.SHO_BUNRUI_CD,
	j.SAI_BUNRUI,
	j.SAI_BUNRUI_CD,
	--j.SYOHIN_MEI,
	seg.UU_ALL
	--limit 1000
)
--select COUNT(*) from sum2;
select * from sum;
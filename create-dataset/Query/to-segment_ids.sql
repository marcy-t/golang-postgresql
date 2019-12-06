-------------------
-- リファクタリング
-------------------
-- ターゲットIDリスト
-- scrap.segments
-- scrap.segment_jans
-- BI.M_KAIIN
-- BI.TR_DU d
-- ---------------------------
--explain with 
with 
to_segment_ids as (
　　　　select DISTINCT
　　　　       seg.id
　　　　,  k.KAIIN_NUM   
　　　　from
　　　　        scrap.segments seg
　　　　,   BI.M_KAIIN k
　　　　,   BI.TR_DU d
　　　　,   scrap.segment_jans ssj
　　　　where 1=1
　　　　-- 購買 メイン結合
　　　　and k.KAIIN_NUM = d.KAIIN_NUM
　　　　-- end
　　　　-- 購買：小分類カテゴリ
　　　　and ssj.segment_id = seg.id
　　　　and d.SYOHIN_CD = ssj.jan
　　　　-- 業態：CVS 
　　　　and d.ALLIANCE_CD in ('9072')
    -- 住所
　　　　and k.JYUSHO_CD is not null
　　　　and k.JYUSHO_CD != '' 
　　　　-- 購買：期間
　　　　and d.SIYO_DATE >= to_char(seg.date_from,'YYYYMMDD')
　　　　and d.SIYO_DATE <= to_char(seg.date_to, 'YYYYMMDD')
　　　　-- 性別
　　　　and k.SEX in ('1','2')
　　　　and k.SEX = (case seg.sex_id when 0 then cast(k.SEX as integer)else seg.sex_id end)
　　　　-- 年齢
　　　　and k.AGE between 15 and 79
　　　　and k.AGE >= (case seg.age_min when 0 then cast(k.AGE as integer)else seg.age_min end)
　　　　and k.AGE <= (case seg.age_max when 0 then cast(k.AGE as integer)else seg.age_max end)
　　　　--limit 10000
　　　　)
select 
*
--    id
--,  COUNT(*) 
from 
    to_segment_ids  
where 1=1
--group by id
order by id asc
;
from sqlalchemy import create_engine
import pandas as pd
import dask.dataframe as dd
import multiprocessing
import time

# vertica
engine = create_engine('vertica+vertica_python://{ID}:{PW}@{HOST}:{PORT}/{DB}')

start=time.time()

SQL = '''
with 
-- ---------------------------
-- ターゲットIDリスト
-- ---------------------------
id_list1 as (
	select 
	ID
	,KAIIN_NUM
	from BI.M_KAIIN k
	where 
	-- 性別
	k.SEX = 2
	-- 年齢   XXX: 本来は年齢計算すべき
	--and to_date(k.SEINENGAPPI_SEIREKI,'YYYYMMDD') >= 20 
	and k.AGE >= 20 and k.AGE <=40
	-- 購買
	and k.KAIIN_NUM in (
		select 
		d.KAIIN_NUM
		from BI.TR_DU d
		where
		-- 業態：CVS
		d.ALLIANCE_CD in ('9011','9025','9065','9051','9043','9088','9072')
		-- 購買：小分類カテゴリ
		and d.SYOHIN_CD in (
		  select SYOHIN_CD from BI.IM_JICFS where SHO_BUNRUI = '222100_ドリンク剤'
		)
		-- 購買：期間
		and d.SIYO_DATE >= 20190101
		and d.SIYO_DATE <= 20190331
	)
)
--select * from id_list1;
--select * from id_list1 limit 100;
-- 68680件
--select count(*) from id_list1;
,
-- ---------------------------
-- ターゲットIDリスト:属性追加、UU設定
-- ---------------------------
id_list1_d as (
	select
	i.ID
	,i.KAIIN_NUM
	-- UU_ALL
	,count(*) over () as UU_ALL
	from id_list1 i
)
--select * from id_list1_d limit 10;
,
-- ----------------------
-- ターゲット集計
-- ----------------------
sum1 as (
	select
		j.DAI_BUNRUI
		,j.DAI_BUNRUI_CD
		,j.CHU_BUNRUI
		,j.CHU_BUNRUI_CD
		,j.SHO_BUNRUI
		,j.SHO_BUNRUI_CD
		,j.SAI_BUNRUI
		,j.SAI_BUNRUI_CD
		,i.UU_ALL
		,count(DISTINCT i.KAIIN_NUM) as UU
	from BI.TR_DU d
	inner join id_list1_d i
	on d.KAIIN_NUM = i.KAIIN_NUM
	inner join BI.IM_JICFS j
	on d.SYOHIN_CD = j.SYOHIN_CD
	where
	-- 業態：CVS
	d.ALLIANCE_CD in ('9011','9025','9065','9051','9043','9088','9072')
	-- 購買期間:固定直近13ヶ月
	and d.SIYO_DATE >= to_char(date_trunc('month', current_date) - '13 month'::intervalym,'YYYYMMDD')
	and d.SIYO_DATE < to_char(date_trunc('month', current_date),'YYYYMMDD')
	group by 1,2,3,4,5,6,7,8,9
)
--select COUNT(*) from sum1;
--select * from sum1 limit 100;
,
-- ---------------------------
-- 比較対象IDリスト
-- ---------------------------
id_list2 as (
	select 
	ID
	,KAIIN_NUM
	from BI.M_KAIIN k
	where 
	-- 性別
	k.SEX = 2
	-- 年齢   XXX: 本来は年齢計算すべき
	--and to_date(k.SEINENGAPPI_SEIREKI,'YYYYMMDD') >= 20 
	and k.AGE >= 20 and k.AGE <=40
	-- 購買
	and k.KAIIN_NUM in (
		select 
		d.KAIIN_NUM
		from BI.TR_DU d
		where
		-- 業態：CVS
		d.ALLIANCE_CD in ('9011','9025','9065','9051','9043','9088','9072')
		-- 購買：小分類カテゴリ
		and d.SYOHIN_CD in (
		  select SYOHIN_CD from BI.IM_JICFS where SHO_BUNRUI = '190200_健康食品'
		)
		-- 購買：期間
		and d.SIYO_DATE >= 20190101
		and d.SIYO_DATE <= 20190331
	)
)
--select * from id_list2 limit 100;
-- 68680件
--select count(*) from id_list2;
,
-- ---------------------------
-- 比較対象IDリスト:属性追加、UU設定
-- ---------------------------
id_list2_d as (
	select
	i.ID
	,i.KAIIN_NUM
	-- UU_ALL
	,count(*) over () as UU_ALL
	from id_list2 i
)
--select * from id_list2_d limit 10;
,
-- ----------------------
-- 比較対象集計
-- ----------------------
sum2 as (
	select
		j.DAI_BUNRUI     AS daibunrui_nm
		,j.DAI_BUNRUI_CD AS daibunrui_cd
		,j.CHU_BUNRUI    AS chubunrui_nm
		,j.CHU_BUNRUI_CD AS chubunrui_cd 
		,j.SHO_BUNRUI    AS shobunrui_nm
		,j.SHO_BUNRUI_CD AS shobunrui_cd
		--,j.SAI_BUNRUI    AS saibunrui_nm
		--,j.SAI_BUNRUI_CD AS saibunrui_cd
		,j.SYOHIN_MEI    AS syohin_nm
		,i.UU_ALL        AS uu_all
		,count(DISTINCT i.KAIIN_NUM) as uu
	from BI.TR_TSUTAYA d
	inner join id_list2_d i
	on d.KAIIN_NUM = i.KAIIN_NUM
	inner join BI.IM_TSUTAYA j
	on d.SYOHIN_CD = j.SYOHIN_CD
	inner join BI.ART_TSUTAYA t
	on t.SYOHIN_CD = j.SYOHIN_CD
	where 1=1
	-- 業態：CVS
	-- d.ALLIANCE_CD in ('9011','9025','9065','9051','9043','9088','9072')
	-- 購買期間:固定直近13ヶ月
	and d.SIYO_DATE >= to_char(date_trunc('month', current_date) - '13 month'::intervalym,'YYYYMMDD')
	and d.SIYO_DATE < to_char(date_trunc('month', current_date),'YYYYMMDD')
	group by 
	j.DAI_BUNRUI,
	j.DAI_BUNRUI_CD,
	j.CHU_BUNRUI,
	j.CHU_BUNRUI_CD,
	j.SHO_BUNRUI,
	j.SHO_BUNRUI_CD,
	--j.SAI_BUNRUI,
	--j.SAI_BUNRUI_CD,
	j.SYOHIN_MEI,
	i.UU_ALL
)
--select COUNT(*) from sum2;
select * from sum2;
'''

try:
  df = pd.read_sql(SQL, engine)
  # セグメントID
  df['segment_id'] = 1
  df.to_csv('DATA-sum-tsutaya-book-sku.tsv', sep='\t')
  print(df.head())
except:
  engine.dispose()
finally:
  engine.dispose()

#df_tsv.to_sql('sum_fm_jicfs', engine, if_exists='append', index=False)

elapsed_time=time.time() - start

print("elapsed_time:{0}".format(elapsed_time)+"[sec]")

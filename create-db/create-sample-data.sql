-- ===========================
-- SCRAP: create sample data
-- ===========================

-- ---------------------------------
-- for PostgreSQL
-- フロントエンド側のサンプルデータ
-- ---------------------------------

-- ---------------------------------
-- Jobs
insert into jobs (name, group_id, user_id, state, auto_flg) 
values ('sample_JICFS1', 1, 1,'New', true);
insert into jobs (name, group_id, user_id, state, auto_flg) 
values ('sample_MMM1', 1, 1,'New', true);
insert into jobs (name, group_id, user_id, state, auto_flg) 
values ('sample_MMM2', 1, 1,'New', true);

-- ---------------------------------
-- Segments, JobSegments

-- JICFS1
insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('赤いきつね購入者（東・西いずれか）', 1, 1, 1, 15, 69, to_date('20180801','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 5, '[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 0 from jobs where name='sample_JICFS1';

insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('カップ麺購入者', 1, 1, 1, 15, 69, to_date('20180801','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 5,'[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 1 from jobs where name='sample_JICFS1';

insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('東洋水産カップ麺購入者', 1, 1, 1, 15, 69, to_date('20180801','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 5,'[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 2 from jobs where name='sample_JICFS1';

insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('緑のたぬき購入者（東・西いずれか）', 1, 1, 1, 15, 69, to_date('20180801','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 5,'[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 3 from jobs where name='sample_JICFS1';

-- MMM1
insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('コカ・コーラ エナジー購入者', 1, 1, null, null, null, to_date('20190701','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 1,'[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 0 from jobs where name='sample_MMM1';

insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('炭酸購入者', 1, 1, null, null, null, to_date('20190701','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 1,'[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 1 from jobs where name='sample_MMM1';

insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('エナジードリンク購入者', 1, 1, null, null, null, to_date('20190701','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 1,'[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 2 from jobs where name='sample_MMM1';

insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('コカ・コーラ購入者', 1, 1, null, null, null, to_date('20190701','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 1,'[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 3 from jobs where name='sample_MMM1';

-- MMM2
insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('アサヒ ドライゼロ購入者', 1, 1, null, 20, 69, to_date('20180801','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 2,'[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 0 from jobs where name='sample_MMM2';

insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('ビール購入者', 1, 1, null, 20, 69, to_date('20180801','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 2,'[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 1 from jobs where name='sample_MMM2';

insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('ノンアルビール購入者', 1, 1, null, 20, 69, to_date('20180801','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 2,'[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 2 from jobs where name='sample_MMM2';

insert into segments (name, group_id, user_id, sex_id, age_min, age_max, date_from, date_to, bunrui_type_id, purchase_condition)
values ('アサヒ スーパードライ購入者', 1, 1, null, 20, 69, to_date('20180801','YYYYMMDD'), to_date('20190731','YYYYMMDD'), 2,'[]');
insert into job_segments (job_id, segment_id, sort) select id, lastval(), 3 from jobs where name='sample_MMM2';

-- ---------------------------------
-- purchase_condition (Segments) 

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg (distinct syohin_mei) from im_jicfs where syohin_cd in ('4901990522731','4901990527866')) as "bunrui6"
) a ) 
where name = '赤いきつね購入者（東・西いずれか）';

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg ('100000_食　品'::varchar)) as "bunrui1"
  ,(select json_agg ('110000_加工食品'::varchar)) as "bunrui2"
  ,(select json_agg ('111200_麺類'::varchar)) as "bunrui3"
  ,(select json_agg ('111203_カップ麺'::varchar)) as "bunrui4"
) a ) 
where name='カップ麺購入者';

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg ('100000_食　品'::varchar)) as "bunrui1"
  ,(select json_agg ('110000_加工食品'::varchar)) as "bunrui2"
  ,(select json_agg ('111200_麺類'::varchar)) as "bunrui3"
  ,(select json_agg ('111203_カップ麺'::varchar)) as "bunrui4"
  ,(select json_agg ('4901990_東洋水産'::varchar)) as "bunrui5"
) a ) 
where name='東洋水産カップ麺購入者';

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg (distinct syohin_mei) from im_jicfs where syohin_cd in ('4901990522748','4901990527873')) as "bunrui6"
) a ) 
where name='緑のたぬき購入者（東・西いずれか）';

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg (distinct bunrui6) from v_mmm where bunrui6_cd in ('4902102133593')) as "bunrui6"
) a ) 
where name='コカ・コーラ エナジー購入者';

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg ('炭酸飲料'::varchar)) as "bunrui1"
) a ) 
where name='炭酸購入者';

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg ('炭酸飲料'::varchar)) as "bunrui1"
  ,(select json_agg ('【炭酸】エナジードリンク'::varchar)) as "bunrui2"
) a ) 
where name='エナジードリンク購入者';

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg ('炭酸飲料'::varchar)) as "bunrui1"
  ,(select json_agg ('【炭酸】コーラ'::varchar)) as "bunrui2"
  ,(select json_agg ('ＣＣＪＣ　コカコーラ'::varchar)) as "bunrui5"
) a ) 
where name='コカ・コーラ購入者';

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg (distinct bunrui6) from v_mmm where bunrui6_cd in ('4904230029991')) as "bunrui6"
) a ) 
where name='アサヒ ドライゼロ購入者';

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg ('ビール類'::varchar)) as "bunrui1"
  ,(select json_agg (distinct bunrui2) from v_mmm where bunrui2 in ('【ビール類】レギュラー', '【ビール類】新ジャンル', '【ビール類】プレミアム', '【ビール類】発泡酒')
  ) as "bunrui2"
) a ) 
where name='ビール購入者';

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg ('ビール類'::varchar)) as "bunrui1"
  ,(select json_agg ('【ビール類】ノンアルコール・ビールテイスト'::varchar)) as "bunrui2"
) a ) 
where name='ノンアルビール購入者';

update segments set purchase_condition = (select row_to_json(a.*, true) from ( select 
  (select json_agg ('ビール類'::varchar)) as "bunrui1"
  ,(select json_agg ('【ビール類】レギュラー'::varchar)) as "bunrui2"
  ,(select json_agg ('【ビール】アサヒ　スーパードライ'::varchar)) as "bunrui5"
) a ) 
where name='アサヒ スーパードライ購入者';

-- 確認
-- select name,purchase_condition from segments where purchase_condition::varchar !='[]';


-- ---------------------------------
-- SegmentJans
insert into segment_jans (segment_id, jan)
select s.id, m.syohin_cd from segments s cross join im_jicfs m
where s.name='赤いきつね購入者（東・西いずれか）'
and m.syohin_cd in ('4901990333269')
;
insert into segment_jans (segment_id, jan)
select s.id, m.syohin_cd from segments s cross join im_jicfs m
where s.name='カップ麺購入者'
and m.dai_bunrui='100000_食　品' and m.chu_bunrui='110000_加工食品' and m.sho_bunrui='111200_麺類' and m.sai_bunrui='111203_カップ麺'
;
insert into segment_jans (segment_id, jan)
select s.id, m.syohin_cd from segments s cross join im_jicfs m
where s.name='東洋水産カップ麺購入者'
and m.dai_bunrui='100000_食　品' and m.chu_bunrui='110000_加工食品' and m.sho_bunrui='111200_麺類' and m.sai_bunrui='111203_カップ麺' and m.maker='4901990_東洋水産'
;
insert into segment_jans (segment_id, jan)
select s.id, m.syohin_cd from segments s cross join im_jicfs m
where s.name='緑のたぬき購入者（東・西いずれか）'
and m.syohin_cd in ('4901990522748','4901990527873')
;

insert into segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from segments s cross join v_mmm m
where s.name='コカ・コーラ エナジー購入者' and m.bunrui_type_id=1
and m.bunrui6_cd in ('4902102133593')
;
insert into segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from segments s cross join v_mmm m
where s.name='炭酸購入者' and m.bunrui_type_id=1
and m.bunrui1 ='炭酸飲料'
;
insert into segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from segments s cross join v_mmm m
where s.name='エナジードリンク購入者' and m.bunrui_type_id=1
and m.bunrui1 ='炭酸飲料' and m.bunrui2='【炭酸】エナジードリンク'
;
insert into segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from segments s cross join v_mmm m
where s.name='コカ・コーラ購入者' and m.bunrui_type_id=1
and m.bunrui1 ='炭酸飲料' and m.bunrui2='【炭酸】コーラ' and m.bunrui5='ＣＣＪＣ　コカコーラ'
;

insert into segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from segments s cross join v_mmm m
where s.name='アサヒ ドライゼロ購入者' and m.bunrui_type_id=2
and m.bunrui6_cd in ('4904230029991')
;
insert into segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from segments s cross join v_mmm m
where s.name='ビール購入者' and m.bunrui_type_id=2
and m.bunrui1 ='ビール類' and m.bunrui2 in ('【ビール類】レギュラー', '【ビール類】新ジャンル', '【ビール類】プレミアム', '【ビール類】発泡酒')
;
insert into segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from segments s cross join v_mmm m
where s.name='ノンアルビール購入者' and m.bunrui_type_id=2
and m.bunrui1 ='ビール類' and m.bunrui2='【ビール類】ノンアルコール・ビールテイスト'
;
insert into segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from segments s cross join v_mmm m
where s.name='アサヒ スーパードライ購入者' and m.bunrui_type_id=2
and m.bunrui1 ='ビール類' and m.bunrui2='【ビール類】レギュラー' and m.bunrui5='【ビール】アサヒ　スーパードライ'
;


-- ---------------------------------
-- for Vertica
-- バックエンド側のサンプルデータ
-- ---------------------------------

-- ---------------------------------
-- SegmentJans
-- select * from scrap.segment_jans where segment_id = 1;
-- select segment_id, count(*) from scrap.segment_jans group by segment_id order by segment_id;
-- truncate table scrap.segment_jans;

insert into scrap.segment_jans (segment_id, jan)
select s.id, m.syohin_cd from scrap.segments s cross join BI.im_jicfs m
where s.id = 1
and m.syohin_cd in ('4901990333269')
;
insert into scrap.segment_jans (segment_id, jan)
select s.id, m.syohin_cd from scrap.segments s cross join BI.im_jicfs m
where s.id = 2
and m.dai_bunrui='100000_食　品' and m.chu_bunrui='110000_加工食品' and m.sho_bunrui='111200_麺類' and m.sai_bunrui='111203_カップ麺'
;
insert into scrap.segment_jans (segment_id, jan)
select s.id, m.syohin_cd from scrap.segments s cross join BI.im_jicfs m
where s.id = 3
and m.dai_bunrui='100000_食　品' and m.chu_bunrui='110000_加工食品' and m.sho_bunrui='111200_麺類' and m.sai_bunrui='111203_カップ麺' and m.maker='4901990_東洋水産'
;
insert into scrap.segment_jans (segment_id, jan)
select s.id, m.syohin_cd from scrap.segments s cross join BI.im_jicfs m
where s.id = 4
and m.syohin_cd in ('4901990333276')
;

insert into scrap.segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from scrap.segments s cross join scrap.v_mmm m
where s.id = 5
and m.bunrui_type_id=1
and m.bunrui6_cd in ('4902102133593')
;
insert into scrap.segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from scrap.segments s cross join scrap.v_mmm m
where s.id = 6
and m.bunrui_type_id=1
and m.bunrui1 ='炭酸飲料'
;
insert into scrap.segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from scrap.segments s cross join scrap.v_mmm m
where s.id = 7
and m.bunrui_type_id=1
and m.bunrui1 ='炭酸飲料' and m.bunrui2='【炭酸】エナジードリンク'
;
insert into scrap.segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from scrap.segments s cross join scrap.v_mmm m
where s.id = 8
and m.bunrui_type_id=1
and m.bunrui1 ='炭酸飲料' and m.bunrui2='【炭酸】コーラ' and m.bunrui5='ＣＣＪＣ　コカコーラ'
;

insert into scrap.segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from scrap.segments s cross join scrap.v_mmm m
where s.id = 9
and m.bunrui_type_id=2
and m.bunrui6_cd in ('4904230029991')
;
insert into scrap.segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from scrap.segments s cross join scrap.v_mmm m
where s.id = 10
and m.bunrui_type_id=2
and m.bunrui1 ='ビール類' and m.bunrui2 in ('【ビール類】レギュラー', '【ビール類】新ジャンル', '【ビール類】プレミアム', '【ビール類】発泡酒')
;
insert into scrap.segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from scrap.segments s cross join scrap.v_mmm m
where s.id = 11
and m.bunrui_type_id=2
and m.bunrui1 ='ビール類' and m.bunrui2='【ビール類】ノンアルコール・ビールテイスト'
;
insert into scrap.segment_jans (segment_id, jan)
select s.id, m.bunrui6_cd from scrap.segments s cross join scrap.v_mmm m
where s.id = 12
and m.bunrui_type_id=2
and m.bunrui1 ='ビール類' and m.bunrui2='【ビール類】レギュラー' and m.bunrui5='【ビール】アサヒ　スーパードライ'
;


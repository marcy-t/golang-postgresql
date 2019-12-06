-- =========================
-- SCRAP: Create DB view
-- =========================

-- =======================
-- SCRAP : view作成
-- =======================

-- ------------------------------
--  v_segments
-- ------------------------------
-- drop view scrap.v_segments;
-- drop view v_segments;
create or replace view scrap.v_segments as (
  select
    j.id as job_id
    ,j.name as job_name
    ,s.id as segment_id
    ,s.name as segment_name
    ,js.sort
  from scrap.segments s 
  inner join scrap.job_segments js
  on s.id = js.segment_id
  inner join jobs j
  on js.job_id = j.id
  order by j.id, js.sort
);


-- ------------------------------
-- MMMビュー（マクロミルマスタ）
-- ------------------------------
-- drop view scrap.v_mmm;
drop view v_mmm;
-- create or replace view scrap.v_mmm as (
create or replace view v_mmm as (
    select
        b.id as bunrui_type_id
         ,m.CAT as cate
         ,m.CD1 as bunrui1_cd
         ,case when b.id in (1,3,5) then m.CD2
               when b.id in (2,4) then m.CD3
               else null end as bunrui2_cd
         ,case when b.id in (1,2) then m.CD8
               when b.id in (3,4) then m.CD4
               when b.id in (5) then m.CD5
               else null end as bunrui3_cd
         ,m.MAKER_CD as bunrui4_cd
         ,case when b.id in (1,2,4) then m.CD5
               when b.id in (3) then m.CD3
               when b.id in (5) then m.CD4
               else null end as bunrui5_cd
         ,m.JAN as bunrui6_cd
         ,m.NAME1 as bunrui1
         ,case when b.id in (1,3,5) then m.NAME2
               when b.id in (2,4) then m.NAME3
               else null end as bunrui2
         ,case when b.id in (1,2) then m.NAME8
               when b.id in (3,4) then m.NAME4
               when b.id in (5) then m.NAME5
               else null end as bunrui3
         ,m.MAKER_NAME as bunrui4
         ,case when b.id in (1,2,4) then m.NAME5
               when b.id in (3) then m.NAME3
               when b.id in (5) then m.NAME4
               else null end as bunrui5
         ,m.ITEM as bunrui6
--     XXX: Postgres用
--     from mmm m
--     XXX: Vertica用
    from BI.MMM m
             inner join bunrui_types b
            --  inner join scrap.bunrui_types b
                        on m.CAT = b.mmm_category_name
);

-- 確認
select * from v_mmm
-- where bunrui_type_id = 1
-- where bunrui_type_id = 2
-- where bunrui_type_id = 3
-- where bunrui_type_id = 4
-- where bunrui_type_id = 5
-- where cate='09_清涼飲料'
-- where cate='02_アルコール'
-- where cate='10_菓子'
-- where cate='01_アイス'
-- where cate='03_インスタント麺'
limit 10;

-- サンプル1：ターゲット：コカ・コーラ エナジー購入者
select * from v_mmm where bunrui_type_id=1 and bunrui6_cd ='4902102133593';
-- サンプル1：比較1：炭酸購入者
select * from v_mmm where bunrui_type_id=1 and bunrui1 ='炭酸飲料';
-- サンプル1：比較2：エナジードリンク購入者
select * from v_mmm where bunrui_type_id=1 and bunrui1 ='炭酸飲料' and bunrui2='【炭酸】エナジードリンク';
-- サンプル1：比較3：コカ・コーラ購入者
select * from v_mmm where bunrui_type_id=1 and bunrui1 ='炭酸飲料' and bunrui2='【炭酸】コーラ' and bunrui5='ＣＣＪＣ　コカコーラ';

-- サンプル2：ターゲット：アサヒ ドライゼロ購入者
select * from v_mmm where bunrui_type_id=2 and bunrui6_cd ='4904230029991';
-- サンプル2：比較1：ビール購入者
select * from v_mmm where bunrui_type_id=2 and bunrui1 ='ビール類' and bunrui2 in ('【ビール類】レギュラー', '【ビール類】新ジャンル', '【ビール類】プレミアム', '【ビール類】発泡酒');
-- サンプル2：比較2：ノンアルビール購入者
select * from v_mmm where bunrui_type_id=2 and bunrui1 ='ビール類' and bunrui2 ='【ビール類】ノンアルコール・ビールテイスト';
-- サンプル2：比較3：アサヒ スーパードライ購入者
select * from v_mmm where bunrui_type_id=2 and bunrui1 ='ビール類' and bunrui2 ='【ビール類】レギュラー' and bunrui5='【ビール】アサヒ　スーパードライ';


-- ---------------------------------------------------
-- LSビュー（ライフスタイル情報）←横持ちを縦持ちに変更
-- ---------------------------------------------------
drop view scrap.v_m_ls;
create or replace view scrap.v_m_ls as (
    with answer_list as (
        select
            l.id
             ,l.kaiin_num
             ,l.answer_date
             ,q.id as question_id
             ,q.name as question_name
             ,case q.id when 1 then marriage
                        when 2 then kids
                        when 3 then home_type
                        when 4 then work
                        when 5 then h_income
                        when 6 then p_income
                        else null end as answer_id
        from BI.M_LS l
                 cross join (
            select 1 as id, '01_未既婚' as name union all
            select 2, '02_子供有無' union all
            select 3, '03_居住形態' union all
            select 4, '04_職業' union all
            select 5, '05_世帯年収' union all
            select 6, '06_個人年収'
        ) q
    )
    select *, answer_id as answer_name from answer_list
    where answer_id is not null
-- 未回答、わからないを破棄
      and not (question_id=5 and answer_id in ('000', '015'))
      and not (question_id=6 and answer_id in ('000', '016'))
);

-- 確認
select * from scrap.v_m_ls limit 1000


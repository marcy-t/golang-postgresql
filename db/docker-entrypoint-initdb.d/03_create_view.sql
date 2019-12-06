/**
   v_mmm
*/
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
    from MMM m
             inner join bunrui_types b
        --  inner join scrap.bunrui_types b
                        on m.CAT = b.mmm_category_name
);

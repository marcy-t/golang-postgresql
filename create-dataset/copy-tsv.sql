COPY scrap.jobs FROM local '/data/postgres_to_vertica/POSTGRES-JOBS.tsv' DELIMITER E'\t' abort on error skip 1;
select * from scrap.jobs; 
COPY scrap.job_segments FROM local '/data/postgres_to_vertica/POSTGRES-JOBS-SEGMENTS.tsv' DELIMITER E'\t' abort on error skip 1;
select * from scrap.job_segments;
COPY scrap.segments FROM local '/data/postgres_to_vertica/POSTGRES-SEGMENTS.tsv' DELIMITER E'\t' abort on error skip 1;
select * from scrap.segments;
COPY scrap.segment_jans FROM local '/data/postgres_to_vertica/POSTGRES-SEGMENTS-JANS.tsv' DELIMITER E'\t' abort on error skip 1;
select * from segment_jans;
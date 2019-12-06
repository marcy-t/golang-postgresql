/**
   bunrui_types
*/
COPY bunrui_types FROM '/docker-entrypoint-initdb.d/101_bunrui_types.csv' DELIMITER ',' CSV HEADER;

/**
   sexes
*/
COPY sexes FROM '/docker-entrypoint-initdb.d/102_sexes.csv' DELIMITER ',' CSV HEADER;

/**
   segments
*/
/*COPY segments FROM '/docker-entrypoint-initdb.d/103_segments.csv' DELIMITER ',' CSV HEADER;*/

/**
   jobs
*/
/*COPY jobs FROM '/docker-entrypoint-initdb.d/104_jobs.csv' DELIMITER ',' CSV HEADER;*/

/**
   job_segments
*/
/*COPY job_segments FROM '/docker-entrypoint-initdb.d/105_job_segments.csv' DELIMITER ',' CSV HEADER;*/

/**
   report_types
*/
COPY report_types FROM '/docker-entrypoint-initdb.d/106_report_types.csv' DELIMITER ',' CSV HEADER;

/**
   segment_jans
*/
/*COPY segment_jans FROM '/docker-entrypoint-initdb.d/107_segment_jans.csv' DELIMITER ',' CSV HEADER;*/

/**
   im_jicfs
*/
COPY im_jicfs FROM '/docker-entrypoint-initdb.d/108_im_jicfs.csv' DELIMITER ',' CSV HEADER;

/**
   mmm
*/
COPY mmm FROM '/docker-entrypoint-initdb.d/109_mmm.csv' DELIMITER ',' CSV HEADER;

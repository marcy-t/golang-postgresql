/**
   bunrui_types
*/
CREATE TABLE IF NOT EXISTS bunrui_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    mmm_category_name VARCHAR(100)
);

/**
   sexes
*/
CREATE TABLE IF NOT EXISTS sexes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(40) UNIQUE NOT NULL
);

/**
   segmentsテーブル　親テーブル
*/
CREATE TABLE IF NOT EXISTS segments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    group_id INTEGER,
    user_id INTEGER,
    sex_id INTEGER REFERENCES sexes(id),
    age_min INTEGER,
    age_max INTEGER,
    date_from TIMESTAMP WITH TIME zone NOT NULL,
    date_to TIMESTAMP WITH TIME zone NOT NULL,
    bunrui_type_id INTEGER REFERENCES bunrui_types(id),
    purchase_condition JSON NOT NULL,
    memo VARCHAR(400)
);
CREATE INDEX idx_segments_group ON segments(group_id);
CREATE INDEX idx_segments_user ON segments(user_id);
CREATE INDEX idx_segments_sex ON segments(sex_id);
CREATE INDEX idx_segments_bunrui ON segments(bunrui_type_id);

/**
   jobs
*/
CREATE TYPE ENUM AS ENUM ('New', 'Processing', 'Finish', 'Error');
CREATE TABLE IF NOT EXISTS jobs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    group_id INTEGER,
    user_id INTEGER,
    create_at TIMESTAMP WITH TIME zone,
    job_finished_at TIMESTAMP WITH TIME zone,
    state ENUM,
    auto_flg BOOLEAN
);
CREATE INDEX idx_jobs_group ON jobs(group_id);
CREATE INDEX idx_jobs_user ON jobs(user_id);

/**
   job_segments
*/
CREATE TABLE IF NOT EXISTS job_segments (
    job_id INTEGER REFERENCES jobs(id),
    segment_id INTEGER REFERENCES segments(id),
    sort INTEGER
);
CREATE INDEX idx_job_segments_job ON job_segments(job_id);
CREATE INDEX idx_job_segments_segment ON job_segments(segment_id);

/**
   report_types
*/
CREATE TABLE IF NOT EXISTS report_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

/**
   job_report_types
*/
CREATE TABLE IF NOT EXISTS job_report_types (
    job_id INTEGER REFERENCES jobs(id) not null,
    report_types_id INTEGER REFERENCES report_types(id) not null
);

/**
   segment_jans
*/
CREATE TABLE IF NOT EXISTS segment_jans (
    segment_id INTEGER REFERENCES segments(id),
    jan VARCHAR(40)
);
CREATE INDEX idx_segment_jans_segment_id ON segment_jans(segment_id);

/**
   im_jicfs
*/
CREATE TABLE IF NOT EXISTS im_jicfs (
    id BIGINT,
    syohin_cd VARCHAR(13),
    syohin_mei VARCHAR(255),
    maker_cd VARCHAR(255),
    dai_bunrui_cd VARCHAR(255),
    chu_bunrui_cd VARCHAR(255),
    sho_bunrui_cd VARCHAR(255),
    sai_bunrui_cd VARCHAR(255),
    maker text,
    dai_bunrui text,
    chu_bunrui text,
    sho_bunrui text,
    sai_bunrui text
);

/**
   mmm
*/
CREATE TABLE IF NOT EXISTS mmm (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME zone,
    cat VARCHAR(255),
    jan VARCHAR(255),
    num VARCHAR(255),
    item VARCHAR(255),
    maker_cd VARCHAR(255),
    maker_name VARCHAR(255),
    cd1 VARCHAR(255),
    name1 VARCHAR(255),
    cd2 VARCHAR(255),
    name2 VARCHAR(255),
    cd3 VARCHAR(255),
    name3 VARCHAR(255),
    cd4 VARCHAR(255),
    name4 VARCHAR(255),
    cd5 VARCHAR(255),
    name5 VARCHAR(255),
    cd6 VARCHAR(255),
    name6 VARCHAR(255),
    cd7 VARCHAR(255),
    name7 VARCHAR(255),
    cd8 VARCHAR(255),
    name8 VARCHAR(255),
    cd9 VARCHAR(255),
    name9 VARCHAR(255),
    cd10 VARCHAR(255),
    name10 VARCHAR(255),
    amount INTEGER,
    number INTEGER,
    ver VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS syokutan (
  id INTEGER,
  word varchar(255),
  main_code INTEGER,
  main_word varchar(255),
  create_at INTEGER,
  update_at INTEGER,
  status VARCHAR(20) DEFAULT 'enable'
)PARTITION by hash(main_code);

/*
    index 設定
*/
CREATE INDEX ON syokutan (word);


/*
振り分けのルール FOR VALUES WITH
パーティション数 MODULUS
振り分けの値を設定 REMAINDER
*/
CREATE TABLE syokutan_hash01 PARTITION OF syokutan
    FOR VALUES WITH (MODULUS 3, REMAINDER 0);

CREATE TABLE syokutan_hash02 PARTITION OF syokutan
    FOR VALUES WITH (MODULUS 3, REMAINDER 1);

CREATE TABLE syokutan_hash03 PARTITION OF syokutan
    FOR VALUES WITH (MODULUS 3, REMAINDER 2);

INSERT INTO syokutan(id, word, main_code, main_word, create_at, update_at)VALUES
(1, '〆さば', '1', '〆鯖','1569888000','1569888000'),
(2,'〆さば', '1', '〆鯖','1572566400','1572566400'),
(3,'二十世紀梨', '2', '〆二十世紀梨','1572566400','1572566400'),
(4,'20世紀梨', '2', '〆二十世紀梨','1572566400','1572566400'),
(5,'NYチーズ', '3', 'NYチーズ','1572566400','1572566400'),
(5,'NYチーズケーキ', '3', 'NYチーズ','1572566400','1572566400')
;

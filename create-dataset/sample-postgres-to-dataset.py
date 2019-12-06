from sqlalchemy import create_engine
import pandas as pd
import numpy as np
import dask.dataframe as dd
import multiprocessing
import time

# vertica
#vertica_engine = create_engine('vertica+vertica_python://scrap:Vertica@SGT@172.19.11.100:5433/CCCBIT')
# postgresql
postgres_engine = create_engine('postgresql://root:root@172.19.11.122:5432/scrap')

start=time.time()

SQL_jobs = '''
select * from jobs;
'''

SQL_job_segments = '''
select * from job_segments;
'''

SQL_segments = '''
select * from segments;
'''

SQL_segment_jans ='''
select * from segment_jans;
'''

try:
  #df_jobs = pd.read_sql(SQL_jobs, postgres_engine)
  #df_jobs.to_csv('POSTGRES-JOBS.tsv',index=False,sep='\t')
  #print(df_jobs)

  #df_job_segments = pd.read_sql(SQL_job_segments, postgres_engine)
  #df_job_segments.to_csv('POSTGRES-JOBS-SEGMENTS.tsv',index=False, sep='\t')
  #print(df_job_segments.head())

  df_segments = pd.read_sql(SQL_segments, postgres_engine)

  df_segments['sex_id'] = df_segments['sex_id'].fillna(0)
  df_segments['sex_id'] = df_segments['sex_id'].astype(int)

  df_segments['age_min'] = df_segments['age_min'].fillna(0)
  df_segments['age_min'] = df_segments['age_min'].astype(int)

  df_segments['age_max'] = df_segments['age_max'].fillna(0)
  df_segments['age_max'] = df_segments['age_max'].astype(int)


  df_segments.to_csv('POSTGRES-SEGMENTS.tsv',index=False, sep='\t')
  print(df_segments.head())

  #df_segment_jans = pd.read_sql(SQL_segment_jans, postgres_engine)
  #df_segment_jans.to_csv('POSTGRES-SEGMENTS-JANS.tsv',index=False, sep='\t')
  #print(df_segment_jans.head())
except:
  postgres_engine.dispose()
finally:
  postgres_engine.dispose()

#df_tsv.to_sql('sum_fm_jicfs', vertica_engine, if_exists='append', index=False)

elapsed_time=time.time() - start

print("elapsed_time:{0}".format(elapsed_time)+"[sec]")

# python postgres-to-dataset.py
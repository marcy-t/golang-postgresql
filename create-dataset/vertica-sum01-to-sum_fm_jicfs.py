from sqlalchemy import create_engine
import pandas as pd
import dask.dataframe as dd
import multiprocessing
import time

# vertica
engine = create_engine('vertica+vertica_python://{ID}:{PW}@{HOST}:{PORT}/{DB}')

start=time.time()

SQL = '''
SELECT * FROM sum_fm_jicfs LIMIT 100;
'''

fname="SCRAP-SUM01.tsv"
df_tsv = pd.read_csv(fname, sep='\t')
df_tsv.to_sql('sum_fm_jicfs', engine, if_exists='append')

print(df_tsv.head())

df = pd.read_sql(SQL, engine)

elapsed_time=time.time() - start

print("elapsed_time:{0}".format(elapsed_time)+"[sec]")
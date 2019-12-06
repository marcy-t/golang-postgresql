from sqlalchemy import create_engine
import pandas as pd
import dask.dataframe as dd
import multiprocessing
import time

# vertica
engine = create_engine('vertica+vertica_python://{ID}:{PW}@{HOST}:{PORT}/{DB_NAME}')

start=time.time()

SQL = '''
{Query}
'''
df = pd.read_sql(SQL, engine)
engine.dispose()
df.to_csv('SCRAP-SUM01.tsv', sep='\t')

elapsed_time=time.time() - start

print("elapsed_time:{0}".format(elapsed_time)+"[sec]")
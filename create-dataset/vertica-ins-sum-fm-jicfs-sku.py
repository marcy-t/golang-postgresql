from sqlalchemy import create_engine
import pandas as pd
import time

# postgresql
engine = create_engine('postgresql://{ID}:{PW}@{HOST}:{PORT}/{DB}')

start=time.time()

SQL = '''
SELECT * FROM sum_fm_jicfs_sku;
'''

fname='DATA-sku_fm_jicfs_sku.tsv'

try:
  reader = pd.read_csv(fname,chunksize=141000, index_col=0, sep='\t')
  df_tsv = reader.get_chunk() # chunkをdataframe
  print(df_tsv.head())
  df_tsv.to_sql('sum_fm_jicfs_sku', engine, if_exists='append', index=False)
except:
  engine.dispose()
finally:
  engine.dispose()


df_all = pd.read_sql(SQL, engine)
print(df_all.head())

elapsed_time=time.time() - start

print("elapsed_time:{0}".format(elapsed_time)+"[sec]")
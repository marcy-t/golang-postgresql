from sqlalchemy import create_engine
import pandas as pd
import time

# postgresql
engine = create_engine('postgresql://{ID}:{PW}@{HOST}:{PORT}/{DB}')

start=time.time()

SQL = '''
SELECT * FROM sum_tsutaya_book_sku;
'''

fname='DATA-sum-tsutaya-book-sku.tsv'

try:
  reader = pd.read_csv(fname,chunksize=127750, sep='\t',usecols=[
  'daibunrui_nm',
  'daibunrui_cd',
  'chubunrui_nm',
  'chubunrui_cd',
  'syohin_nm',
  'uu_all',
  'uu',
  'segment_id'
  ])
  df_tsv = reader.get_chunk() # chunkをdataframe
  print(df_tsv.head())
  df_tsv.to_sql('sum_tsutaya_book_sku', engine, if_exists='append', index=False)
except:
  engine.dispose()
finally:
  engine.dispose()


df_all = pd.read_sql(SQL, engine)
print(df_all.head())

elapsed_time=time.time() - start

print("elapsed_time:{0}".format(elapsed_time)+"[sec]")
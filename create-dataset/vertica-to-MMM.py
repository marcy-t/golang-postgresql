from sqlalchemy import create_engine
import pandas as pd
import dask.dataframe as dd
import multiprocessing
import time

# vertica
engine = create_engine('vertica+vertica_python://{ID}:{PW}@{HOST}:{PORT}/{DB}')

start=time.time()

SQL = '''
SELECT
    cat
,   jan
,   num
,   item
,   maker_cd
,   maker_name
,   cd1
,   name1
,   cd2
,   name2
,   cd3
,   name3
,   cd4
,   name4
,   cd5
,   name5
,   cd6
,   name6
,   cd7
,   name7
,   cd8
,   name8
,   cd9
,   name9
,   cd10
,   name10
,   amount
,   number
,   ver
FROM
    BI.MMM
;
'''

try:
  df = pd.read_sql(SQL, engine)
  df.to_csv('DATA-MMM.tsv', sep='\t')
  print(df.head())
except:
  engine.dispose()
finally:
  engine.dispose()

#df_tsv.to_sql('sum_fm_jicfs', engine, if_exists='append', index=False)

elapsed_time=time.time() - start

print("elapsed_time:{0}".format(elapsed_time)+"[sec]")
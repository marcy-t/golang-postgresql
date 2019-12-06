from sqlalchemy import create_engine
import pandas as pd
import time

# vertica
vertica_engine = create_engine('vertica+vertica_python://scrap:Vertica@SGT@172.19.11.99:5433/CCCBIT')

# postgresql
postgres_engine = create_engine('postgresql://root:root@172.19.11.122:5432/scrap')

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

fname='DATA-MMM.tsv'

try:
  df_all = pd.read_sql(SQL, vertica_engine)
  vertica_engine.dispose()

  print(df_all.head())
  df_all.to_sql('mmm', postgres_engine, if_exists='append', index=False)
except:
  vertica_engine.dispose()
  postgres_engine.dispose()
finally:
  postgres_engine.dispose()

elapsed_time=time.time() - start

print("elapsed_time:{0}".format(elapsed_time)+"[sec]")
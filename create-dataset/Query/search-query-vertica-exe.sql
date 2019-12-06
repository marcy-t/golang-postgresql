select
-- ,user_name
session_id
,request_id
,is_executing
,start_timestamp
,substring(request,1,80) as request
,memory_acquired_mb
from query_requests
where is_executing ='t'
order by start_timestamp desc
limit 20;
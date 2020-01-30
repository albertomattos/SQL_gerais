--select count(*) from int_xml

select 
   segment_name table_name, sum(bytes)/(1024*1024) MBytes 
from user_extents Where segment_type='TABLE' 
and segment_name IN ('INT_TRANSACAO','INT_XML')
group by segment_name;

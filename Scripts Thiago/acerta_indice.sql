set linesize 1000 time on trimspool on;
spool indice.sql;
--spool transp_indice.sql;
select
'alter index '||INDEX_NAME ||' rebuild tablespace mxmidad; '
from user_indexes
where table_owner = upper('&owner')
--and tablespace_name = upper('&tablespace');

spool off;
--@transp_indice.sql;
indice.sql;

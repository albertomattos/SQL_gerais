set head off
set echo off
set pagesize 10000
spool indices.sql
select 'alter index '||index_name||' rebuild tablespace mxmidad;'
 from user_indexes;
-- WHERE TABLESPACE_NAME<>'MXMIDAD';
spool off
@indices
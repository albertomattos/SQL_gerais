--select * from all_tables where upper(table_name) like 'BACKUP';

select * from V$RMAN_OUTPUT order by sid desc
select * from V$RMAN_OUTPUT  where output like '26/08/2016'

select output from GV$RMAN_OUTPUT where session_recid = &SESSION_RECID and session_stamp = &SESSION_STAMP order by recid;

select output from GV$RMAN_OUTPUT where output like '%26/08/2016%'
SELECT * FROM V$LOCKED_OBJECT;
SELECT * FROM GV$LOCKED_OBJECT;
select * from v$global_blocked_locks;
select * from dictionary where upper(table_name) like '%LOCKED%'
select * from v$sqlstats order by elapsed_time desc
select * from v$sql_hint
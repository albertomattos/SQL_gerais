SELECT DECODE(TOTALQ, 0, 'No Requests',
   WAIT/TOTALQ || ' HUNDREDTHS OF SECONDS') "AVERAGE WAIT TIME PER REQUESTS"
  FROM V$QUEUE
 WHERE TYPE = 'COMMON';

--total cursors open, by session 
 select a.value, s.username, s.sid, s.serial#
from v$sesstat a, v$statname b, v$session s
where a.statistic# = b.statistic#  and s.sid=a.sid
and b.name = 'opened cursors current';

select sum(a.value)
from v$sesstat a, v$statname b, v$session s
where a.statistic# = b.statistic#  and s.sid=a.sid
and b.name = 'opened cursors current';

select count(*) from v$open_cursor;

--total cursors open, by username & machine
select sum(a.value) total_cur, avg(a.value) avg_cur, max(a.value) max_cur, 
s.username, s.machine
from v$sesstat a, v$statname b, v$session s 
where a.statistic# = b.statistic#  and s.sid=a.sid
and b.name = 'opened cursors current' 
group by s.username, s.machine
order by 1 desc;

select max(a.value) as highest_open_cur, p.value as max_open_cur
  from v$sesstat a, v$statname b, v$parameter p
  where a.statistic# = b.statistic# 
  and b.name = 'opened cursors current'
  and p.name= 'open_cursors'
  group by p.value;
  
  --session cached cursors, by session
select a.value, s.username, s.sid, s.serial#
from v$sesstat a, v$statname b, v$session s
where a.statistic# = b.statistic#  and s.sid=a.sid
and b.name = 'session cursor cache count' ;

select c.user_name, c.sid, sql.sql_text
from v$open_cursor c, v$sql sql
where c.sql_id=sql.sql_id
and c.sid=&sid;

select cach.value cache_hits, prs.value all_parses, 
  prs.value-cach.value sess_cur_cache_not_used
  from v$sesstat cach, v$sesstat prs, v$statname nm1, v$statname nm2
  where cach.statistic# = nm1.statistic#  
  and nm1.name = 'session cursor cache hits' 
  and prs.statistic#=nm2.statistic#
  and nm2.name= 'parse count (total)'
  and cach.sid= &sid and prs.sid= cach.sid ;
  
  --session cached cursors, for a given SID, compared to max
select a.value curr_cached, p.value max_cached, s.username, s.sid, s.serial#
from v$sesstat a, v$statname b, v$session s, v$parameter2 p
where a.statistic# = b.statistic#  and s.sid=a.sid and a.sid=&sid
and p.name='session_cached_cursors'
and b.name = 'session cursor cache count' ;
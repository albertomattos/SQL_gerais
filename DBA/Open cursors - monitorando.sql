select a.value, s.username, s.sid, s.serial#
from v$sesstat a, v$statname b, v$session s
where a.statistic# = b.statistic#  and s.sid=a.sid
and b.name = 'opened cursors current';

select count(a.value)
from v$sesstat a, v$statname b, v$session s
where a.statistic# = b.statistic#  and s.sid=a.sid
and b.name = 'opened cursors current';

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
  
  select 
   max(sess.value) from v$sesstat sess, v$statname b, v$session s
where sess.statistic# = b.statistic# 
and s.sid=sess.sid
and b.name = 'opened cursors current';
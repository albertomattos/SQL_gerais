--usuários em lock:
select w.waiting_session, s.username, s.sid, s.serial#,	w.holding_session, s1.username, s1.sid,	s1.serial#,	w.lock_type
from 	dba_waiters w, v$session s, v$session s1 where w.waiting_session=s.sid and w.holding_session=s1.sid

--maiores waits:
select class, count, time from v$waitstat where count > 0 order by class; 

--Script para verificar GETS e WAITS em segmentos UNDO
select rownum, extents, rssize, xacts, gets, waits, writes from v$rollstat order by rownum;
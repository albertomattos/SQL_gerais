--CREATE TABLE PRE_SYSTEM_EVENT AS SELECT * FROM V$SYSTEM_EVENT;

--CREATE TABLE POS_SYSTEM_EVENT AS SELECT * FROM V$SYSTEM_EVENT;

SELECT A.EVENT, A.TIME_WAITED, B.TIME_WAITED, (B.TIME_WAITED-A.TIME_WAITED) DIFF
FROM PRE_SYSTEM_EVENT A, POS_SYSTEM_EVENT B
WHERE A.EVENT = B.EVENT
AND A.TIME_WAITED IS NOT NULL
AND ((B.TIME_WAITED-A.TIME_WAITED) > 0)
AND A.WAIT_CLASS != 'Idle'
ORDER BY DIFF;

select * from v$sql

select sql_text, object_status, first_load_time, username, sid, lockwait, sql.LAST_ACTIVE_TIME
from v$session ses, v$sql sql
where ses.sql_id = sql.sql_id

select * from v$session

SELECT W.SID, W.EVENT, W.SECONDS_IN_WAIT
FROM V$SESSION_WAIT W
WHERE W.EVENT NOT LIKE 'SQL*Net%'
AND W.EVENT NOT IN ('pmon timer', 'smon timer', 'rdbms ipc message', 'wakeup time manager', 'jobq slave wait',
'PL/SQL lock timer') ORDER BY W.SECONDS_IN_WAIT, W.SID;
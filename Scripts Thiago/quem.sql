col schemaname format a15
col osuser format a15
col program a20
SET LINESIZE 1000
SELECT schemaname,osuser,PROGRAM,machine
FROM V$SESSION;
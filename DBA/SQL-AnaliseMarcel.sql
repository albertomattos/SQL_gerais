select machine, count(1) from v$session group by machine order by count(1) desc;

select count(1) from v$session;
select * from v$session;

select * from v$session where machine='HOSPITAL\PAINEL-03';

select elapsed_seconds, target, sofar, totalwork, start_time, last_update_time, sql_plan_options, sql_id
from V$SESSION_LONGOPS  where /*opname = 'Table Scan' and */sofar<>totalwork;

select * from V$SESSION_LONGOPS  where sofar<>totalwork;

SELECT SID, SERIAL#, opname, SOFAR, TOTALWORK,
ROUND(SOFAR/TOTALWORK*100,2) COMPLETE
FROM   V$SESSION_LONGOPS
WHERE
TOTALWORK != 0
AND    SOFAR != TOTALWORK
order by 1;

SELECT SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM V$SESSION_LONGOPS
WHERE OPNAME LIKE 'RMAN%'
  AND OPNAME NOT LIKE '%aggregate%'
  AND TOTALWORK != 0
  AND SOFAR  != TOTALWORK;

select *  from V$SESSION_LONGOPS  where opname = 'Table Scan' order by elapsed_seconds desc;
select *  from V$SESSION_LONGOPS/*  where opname = 'Table Scan'*/ order by start_time desc;

ALTER SYSTEM KILL SESSION '2087,19673';

select * from v$sql where sql_id = '9mh3r78ntcsu0';
select * from v$

select elapsed_seconds, sofar, totalwork, start_time, last_update_time, sql_plan_options, sql_id
select * from V$SESSION_LONGOPS  where opname = 'Table Scan' and target like '%PRESCRICAO_PAC%' order by elapsed_seconds desc;

SELECT SID, SERIAL#, opname, SOFAR, TOTALWORK, ROUND(SOFAR/TOTALWORK*100,2) COMPLETE
FROM   V$SESSION_LONGOPS WHERE TOTALWORK != 0 AND SOFAR != TOTALWORK order by 1;

select * from v$sql where sql_id in (select sql_id  from V$SESSION_LONGOPS  where opname = 'Table Scan'
 --and sofar<>totalwork
 );

select * from v$sql where sql_id in (select sql_id  from V$SESSION_LONGOPS  where opname = 'Table Scan'
 and target like '%PRESCRICAO_PAC%');
 
 
select *  from V$SESSION_LONGOPS  where opname = 'Table Scan'
 and sofar<>totalwork;

select distinct  owner, to_char( last_analyzed, 'YYYY/MM') 
from dba_tables where table_name='INTP_LOGPROCESSO';
where owner in (select distinct username from v$session where username not in ('SYS','SYSTEM')) 

select * from v$session_wait order by seconds_in_wait desc

SELECT s.sid, w.state, w.event, s.sql_id, s.sql_child_number, w.seq#, w.seconds_in_wait, w.p1text||'= '||w.p1 p1,
	w.p2text||'= '||w.p2 p2, w.p3text||'= '||w.p3 p3
FROM v$session s, v$session_wait w 
WHERE w.sid = s.sid AND w.sid In (select sid from v$session_wait)-- "633";


select * 
--SEQUENCIAL, SEQ_CONTROLE, DATA_INC, HORA_INC, OBSERVACAO, STATUS 
from INTP_LOGPROCESSO where  SEQ_CONTROLE = 1095088 and data_inc between  trunc(sysdate) and trunc(sysdate+1);


select  SEQUENCIAL, SEQ_CONTROLE, DATA_INC, HORA_INC, OBSERVACAO, STATUS 
from INTP_LOGPROCESSO where  SEQ_CONTROLE = 1065653 AND trunc(data_inc) = trunc(sysdate) ;
SELECT DISTINCT ESMOVCAD.COD_PAC, FK_DOC_PED_CONS FROM ESMOVCAD, ESMOVITE 
WHERE ESMOVCAD.TIPO_DOCUMENTO = ESMOVITE.TIPO_DOCUMENTO
AND ESMOVCAD.DOCUMENTO = ESMOVITE.DOCUMENTO
AND ESMOVITE.FK_TP_DOC_PED_CONS = 'PED' AND
ESMOVITE.FK_DOC_PED_CONS_REP = '0047760'  

/*
 CREATE  INDEX "ADMWPD"."INDX_SEQ_CONTROLE" ON "ADMWPD"."INTP_LOGPROCESSO" ("SEQ_CONTROLE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "WPDINDICES" ;*/
  
  CREATE  INDEX "MGINT"."INDX_TRN_IN_ID" ON "MGINT"."WPD_INT_XML" ("TRN_IN_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TSI_MEGA" ;
  
  select * from v$backup_files
  
  SELECT s.username,
     s.osuser,
     s.sid,
     s.serial#,
     p.spid,
     s.status,
     s.machine,
     s.program,
     TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
   FROM v$session s
  inner join v$process p
     on s.paddr = p.addr
  WHERE s.status = 'ACTIVE'
    and s.type <> 'BACKGROUND'
    
    
    select * from V$MEMORY_RESIZE_OPS
    select * from V$SGA_DYNAMIC_FREE_MEMORY
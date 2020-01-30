select * from v$rman_output
--Caso dê o erro ORA-19625, rodar os scipts abaixo:
--rman target /
--allocate channel for delete type disk;
--change archivelog all validate;
--crosscheck archivelog all;
--list expired archivelog all;

--RMAN> LIST BACKUP SUMMARY;
--CROSSCHECK BACKUP;
--DELETE NOPROMPT OBSOLETE;
--delete noprompt expired backup;

--Acompanhar rman em execução
select sid, start_time, totalwork sofar, round((sofar/totalwork) * 100,2) pct_done
from v$session_longops where totalwork > sofar AND opname NOT LIKE '%aggregate%' AND opname like 'RMAN%';

select sid, start_time, totalwork sofar, round((sofar/totalwork) * 100,2) pct_done
from v$session_longops where totalwork > sofar AND opname NOT LIKE '%aggregate%' AND opname like '%EXPORT%';

select sid, start_time, totalwork sofar, round((sofar/totalwork) * 100,2) pct_done
from v$session_longops where totalwork > sofar AND opname NOT LIKE '%aggregate%' AND opname like '%IMPORT%';

select sid, spid, client_info, event, seconds_in_wait, p1, p2, p3 from v$process p, v$session s where p.addr = s.paddr
 and client_info like 'rman channel=%';
 
select sid, row_type, operation, status, to_char(start_time,'dd-mm-yyyy hh24:mi:ss') start_time, to_char(end_time,'dd-mm-yyyy hh24:mi:ss')
end_time from v$rman_status order by start_time desc;
 
 --Para matar a sessão:
 select b.sid, b.serial#, a.spid, b.client_info from v$process a, v$session b where a.addr=b.paddr and client_info like 'rman%';
 alter system kill session 'SID,SERIAL#' immediate;
 alter system kill session '1730,5663' immediate;
 
 --Alguns comandos:
 
 CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT 'C:/backup/bkp_%d_%t_%s.bak'
 LIST BACKUP SUMMARY;
 LIST BACKUP;
 RESTORE DATABASE VALIDATE;
 CONFIGURE CHANNEL DEVICE TYPE DISK CLEAR;
 CONFIGURE CHANNEL 1 DEVICE TYPE DISK CLEAR;
 
Nomenclatura de Backup set = bkp_%d_%t_%s.rman
Sobre a nomenclatura utilizada, segue a explicação:
bkp_ = Nome inicial dos backupsets gerados, ou seja, definido por mim, é um valor fixo.
%d = Variável do RMAN para identificar o nome do banco de dados.
%t = Variável do RMAN para o Time Stamp do backup set.
%s = Variável do RMAN para identificar a sequência do backup set.


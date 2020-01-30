--Archive log (dentro do SQLPLUS)
/*select log_mode from v$database;
select * from V$ARCHIVED_LOG;

--ver espaço utilizado:
select * from v$recovery_file_dest;*/
select * from V$RECOVERY_AREA_USAGE;
/*select * from v$flash_recovery_area_usage;
SELECT (100 - sum(percent_space_used)) + sum(percent_space_reclaimable)FROM v$flash_recovery_area_usage;
(100-SUM(PERCENT_SPACE_USED))+SUM(PERCENT_SPACE_RECLAIMABLE)
--

select * from dba_directories;

archive log list
--Verificar parâmetros de espaço e local (via SQLPLUS)
show parameter DB_RECOVERY_FILE_DEST
show parameter recovery
--
V$DATABASE
V$ARCHIVED_LOG
V$ARCHIVE_DEST
V$ARCHIVE_PROCESSES
V$BACKUP_REDOLOG
V$LOG
V$LOG_HISTORY

DELETE NOPROMPT ARCHIVELOG UNTIL SEQUENCE = 300;
delete NOPROMPT FORCE obsolete;
allocate channel for maintenance type disk;
delete obsolete device type disk;
delete expired backup;
allocate channel for maintenance device type 'SBT_TAPE' parms;
select * from V$BACKUP_FILES where status <> 'AVAILABLE' and status is not null;
select * from V$RMAN_STATUS;
select * from V$RECOVER_FILE;
select * from V$BACKUP_SET;

CROSSCHECK BACKUP DEVICE TYPE DISK COMPLETED BETWEEN '01/01/2012' AND '01/05/2013';
*/
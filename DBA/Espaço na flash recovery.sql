SELECT name, ceil( space_limit / 1024 / 1024) SIZE_M, ceil( space_used  / 1024 / 1024) USED_M,
ceil( space_reclaimable  / 1024 / 1024) RECLAIMABLE_M, decode( nvl( space_used, 0), 0, 0,
ceil ( ( ( space_used - space_reclaimable ) / space_limit) * 100) ) PCT_USED FROM v$recovery_file_dest ORDER BY name

--RMAN> LIST BACKUP SUMMARY;
--CROSSCHECK BACKUP;
--DELETE NOPROMPT OBSOLETE;
--delete noprompt expired backup;

SELECT name, ceil( space_limit / 1024 / 1024) SIZE_M,
           ceil( space_used  / 1024 / 1024) USED_M,
           decode( nvl( space_used, 2),
           0,
           0,
           ceil ( ( space_used / space_limit) * 100) ) PCT_USED
   FROM v$recovery_file_dest
   ORDER BY name
   


SELECT Name, (SPACE_LIMIT/1024/1024/1024) Space_Limit_GB, SPACE_USED/1024/1024/1024 Space_Used_GB, SPACE_RECLAIMABLE, NUMBER_OF_FILES 
FROM V$RECOVERY_FILE_DEST;

select * from V$RECOVERY_AREA_USAGE;

select * from v$flash_recovery_area_usage;

SELECT (100 - sum(percent_space_used)) + sum(percent_space_reclaimable) FROM v$flash_recovery_area_usage;

select * from v$recovery_file_dest;
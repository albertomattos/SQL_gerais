select * from v$parameter
where upper(name)='DB_RECOVERY_FILE_DEST'
and value is not null;
--% utilizado por cada filename
SELECT file_name, tablespace_name, round((bytes/maxbytes)*100,0) perc_usado FROM DBA_DATA_FILES WHERE TABLESPACE_NAME in ('SYSTEM', 'WPDDADOS', 'WPDINDICES', 'TSD_MEGA',
'TSI_MEGA','VETORH_INDEX','VETORH_DATA') order by 2,3

SELECT file_name, tablespace_name, round((bytes/maxbytes)*100,0) perc_usado FROM DBA_DATA_FILES WHERE TABLESPACE_NAME in ('WPDINDICES') order by 2,3

--Tablespace
SELECT object_type, message_type, message_level, reason, suggested_action FROM dba_outstanding_alerts;


--alter tablespace wpddados offline normal;
SELECT * FROM DBA_DATA_FILES


--and round((bytes/maxbytes)*100,2)<>100 and file_name not like '%H:\ORADATA\PROD\DATAFILE\O4_MF_WPDDADOS_884C8DDX_.DBF%' order by 3;
/*ALTER TABLESPACE WPDINDICES ADD DATAFILE 'H:\ORADATA\PROD\DATAFILE\05_MF_WPDINDIC_884CDGQL_.DBF' SIZE 128M AUTOEXTEND ON;
--ALTER TABLESPACE SYSTEM DELETE DATAFILE 'H:\ORADATA\PROD\DATAFILE\O5_MF_WPDDADOS_884C8DDX_.DBF';
--ALTER DATABASE DATAFILE 'H:\ORADATA\PROD\DATAFILE\O5_MF_WPDDADOS_884C8DDX_.DBF' OFFLINE DROP;
alter tablespace system offline;*/

SELECT file_name, tablespace_name, round((bytes/maxbytes)*100,2) perc_usado FROM DBA_DATA_FILES WHERE TABLESPACE_NAME = ('WPDDADOS')
/*
DROP TABLESPACE TSD_MEGA INCLUDING CONTENTS AND DATAFILES;

purge recyclebin;

ALTER TABLESPACE system OFFLINE IMMEDIATE
lter database datafile 'H:\ORADATA\TREINO\DATAFILE\O2_MF_WPDDADOS_B7SN1902_.DBF' resize 512M;*/

/*select	a.TABLESPACE_NAME, a.BYTES bytes_used, b.BYTES bytes_free, b.largest,
	round(((a.BYTES-b.BYTES)/a.BYTES)*100,2) percent_used
from 	
	( select TABLESPACE_NAME, sum(BYTES) BYTES from dba_data_files group by TABLESPACE_NAME	)	a,
	(	select TABLESPACE_NAME,	sum(BYTES) BYTES,	max(BYTES) largest from dba_free_space group by TABLESPACE_NAME	)	b
where 	a.TABLESPACE_NAME=b.TABLESPACE_NAME
order 	by ((a.BYTES-b.BYTES)/a.BYTES) desc
*/
--select * from dba_free_space where tablespace_name = 'WPDINDICES'

--select 	TABLESPACE_NAME, sum(BYTES) Total_free_space,	max(BYTES) largest_free_extent from 	dba_free_space group by TABLESPACE_NAME

/*
--select sum(bytes) from dba_free_space where tablespace_name = 'WPDINDICES'

--select 	USERNAME,	CREATED, PROFILE,	DEFAULT_TABLESPACE,	TEMPORARY_TABLESPACE from 	dba_users order by 4

select	OWNER, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES
from 	dba_segments
where	TABLESPACE_NAME = 'WPDINDICES'
and	OWNER not in ('SYS','SYSTEM')
order 	by BYTES descOWNER, SEGMENT_NAME

select name, bytes, creation_time, status from v$datafile order by name

select * from dba_data_files

--ALTER TABLESPACE SYSTEM ADD DATAFILE 'H:\ORADATA\TREINO\DATAFILE\O2_MF_WPDINDIC_B7SN6WBT_.DBF' SIZE 128M AUTOEXTEND ON;

--SELECT TABLESPACE_NAME, FILE_NAME, FILE_ID

--SELECT * FROM DBA_DATA_FILES WHERE TABLESPACE_NAME = 'WPDDADOS';

--ALTER TABLESPACE SYSTEM DELETE DATAFILE 'H:\ORADATA\TREINO\DATAFILE\O2_MF_WPDDADOS_B7SN1901_.DBF';
ALTER TABLESPACE WPDDADOS ADD DATAFILE 'H:\ORADATA\PROD\DATAFILE\O3_MF_WPDDADOS_884C8DDX_.DBF' SIZE 128M AUTOEXTEND ON;
--ALTER TABLESPACE TEMPAGFA ADD TEMPFILE 'H:\ORADATA\PROD\DATAFILE\02_TEMPAGFA.TMP' SIZE 128M AUTOEXTEND ON;
--ALTER TABLESPACE TEMP SHRINK TEMPFILE 'H:\ORADATA\PROD\DATAFILE\O2_MF_TEMP_85S6R0JT_.TMP';

ALTER TABLESPACE users
    DEFAULT STORAGE (
       NEXT 100K
       MAXEXTENTS 20
       PCTINCREASE 0);
       
alter database datafile 'H:\ORADATA\TREINO\DATAFILE\O2_MF_WPDDADOS_8ZM12CCF_.DBF' AUTOEXTEND ON;*/

select tablespace_name, bytes, autoextensible from dba_data_files where tablespace_name = 'WPDINDICES';

select * from dba_resumable;

select max(BYTES) from   dba_free_space where  tablespace_name = 'WPDINDICES';


create index FK_MODCAD_LOGCAD on FALOGCAD (SISTEMA, MODULO)

create index IE_LOGCAD_2 on FALOGCAD (SISTEMA, DATA DESC)

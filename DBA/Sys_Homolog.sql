SELECT file_name, tablespace_name, round((bytes/maxbytes)*100,2) perc_usado FROM DBA_DATA_FILES
ALTER DATABASE DATAFILE 'C:\app\administrador\oradata\homolog\TSD_MEGA.DBF' OFFLINE;
ALTER DATABASE DATAFILE 'C:\app\administrador\oradata\homolog\TSD_MEGA.DBF' DROP INCLUDING DATAFILES;

CREATE TABLESPACE TSD_MEGA DATAFILE 'TSD_MEGA' SIZE 2147483648 AUTOEXTEND ON NEXT 1073741824 MAXSIZE UNLIMITED

CREATE TABLESPACE TSD_MEGA LOGGING DATAFILE 'C:\app\administrador\oradata\homolog\TSD_MEGA.DBF' SIZE 12280M  AUTOEXTEND ON NEXT 102400K MAXSIZE 32767M EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE TSI_MEGA LOGGING DATAFILE  'C:\app\administrador\oradata\homolog\TSI_MEGA.DBF' SIZE 2350M  AUTOEXTEND ON NEXT 102400K MAXSIZE 32767M EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

alter tablespace TSD_MEGA add DATAFILE 'C:\app\administrador\oradata\homolog\TSD_MEGA02.DBF' SIZE 128M AUTOEXTEND ON;

drop tablespace TSD_MEGA including contents and datafiles;
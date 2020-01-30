select * from dba_users where DEFAULT_TABLESPACE = 'TSD_MEGA'

select distinct owner from dba_segments where owner in (select username from dba_users where default_tablespace not in ('SYSTEM','SYSAUX'));

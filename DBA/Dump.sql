select * from USER_DATAPUMP_JOBS;
SELECT OWNER_NAME,JOB_NAME FROM DBA_DATAPUMP_JOBS;
SELECT owner_name, job_name, operation, job_mode, state FROM dba_datapump_jobs;
--Digitar na linha de comando do servidor:
--impdp username/password@database attach=nome_do_job
--$ Import>kill_job
--Are you sure you wish to stop this job (y/n): y
select * from DBA_DATAPUMP_SESSIONS;
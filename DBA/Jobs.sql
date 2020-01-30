select * from dictionary where table_name like '%JOB%'
select * from dictionary where table_name like '%RUNNING%'

select * from dba_jobs_running
select * from dba_jobs
select owner, job_name, elapsed_time, cpu_used from all_scheduler_running_jobs


select last_start_date, last_run_duration, next_run_date, run_count, failure_count from dba_scheduler_jobs
where job_name = 'JOB_USU_INAT_MEGA'
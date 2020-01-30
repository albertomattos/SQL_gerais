begin
  sys.dbms_scheduler.create_job(job_name            => 'SYS.JOB_LOGOUT_MEGA',
                                job_type            => 'PLSQL_BLOCK',
                                job_action          => 'BEGIN logout_mega; END;',
                                start_date          => to_date('27-11-2012 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),
                                repeat_interval     => 'Freq=Daily;ByHour=05',
                                end_date            => to_date(null),
                                job_class           => 'DEFAULT_JOB_CLASS',
                                enabled             => true,
                                auto_drop           => false,
                                comments            => 'Dá um logout nos usuários Mega às 5 da manhã');
end;
/

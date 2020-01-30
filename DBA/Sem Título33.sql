SELECT
  tablespace_name,
  file_name,
  bytes/(1024*1024) tamanho_MB,
  maxbytes/(1024*1024) maximo_MB,
  status
  FROM dba_temp_files
  ORDER BY tablespace_name, file_name;
  
  SELECT
  su.username,
  s.osuser,
  su.tablespace,
  TO_CHAR (s.logon_time, 'dd/mm/yyyy hh:mi:ss') logon,
  s.sid, s.serial#,
  s.machine,
  s.terminal,
  s.program
  FROM
    v$sort_usage su JOIN
      v$session s ON su.session_addr = s.saddr;
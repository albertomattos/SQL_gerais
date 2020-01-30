SELECT
   s.sid                sid
 , s.serial#            serial_id
 , lpad(s.status,9)     session_status
 , lpad(s.username,12)  oracle_username
 , lpad(s.osuser,9)     os_username
 , lpad(p.spid,7)       os_pid
 , s.program            session_program
 , lpad(s.machine,14)   session_machine
 , sstat.value          cpu_value
FROM v$process p
 , v$session  s
 , v$sesstat  sstat
 , v$statname statname
WHERE p.addr              = s.paddr AND s.sid               = sstat.sid AND statname.statistic# = sstat.statistic# AND statname.name       = 'CPU used by this session'
ORDER BY cpu_value DESC;
select s.sid, p.spid, s.client_info from v$process p, v$session s
where p.addr = s.paddr and client_info like '%RMAN%'
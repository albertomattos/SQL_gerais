select s.sid, s.serial#, s.status, p.spid 
from v$session s, v$process p 
where s.username = 'ADMWPD'
and p.addr (+) = s.paddr;
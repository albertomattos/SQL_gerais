select
'SELECT comanda,''||trim(tabname)||'''','||
'count(*) FROM '||trim(tabname)||' where comanda = '1739271' GROUP BY 1,2 ORDER BY 1,2'
from systables, syscolumns
where
systables.tabid=syscolumns.tabid
and
colname='COMANDA'

select * from SYSTABLES

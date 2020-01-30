--analyze table nometab compute statistics

--exec dbms_stats.gather_schema_stats(ownname=> 'MANAGER' , cascade=> TRUE);
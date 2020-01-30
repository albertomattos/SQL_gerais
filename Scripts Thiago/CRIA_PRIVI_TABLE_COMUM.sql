SPOOL PRIVILEGIO_TABLE.SQL
set heading off
set feedback off

SELECT 'GRANT ALL ON '||object_name||' TO MXMSYS, MXMDBA, AMERCON;'
FROM ALL_OBJECTS
WHERE OBJECT_TYPE='TABLE'
and owner='MXMCOMUM'
;

set heading on
set feedback on

spool off;
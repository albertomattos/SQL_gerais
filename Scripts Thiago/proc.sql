ACCEPT V_PROCEDURE PROMPT 'ENTRE COM O NOME DA PROCEDURE: ';
SET LINESIZE 300 PAGESIZE 1000 trimspool on verify off heading off arraysize 10;

SPOOL PROC1.SQL;

select decode(substr(text,1,9),'PROCEDURE','CREATE OR REPLACE '||TEXT,TEXT) TEXT
from user_source
where NAME LIKE UPPER('&V_PROCEDURE');

SPOOL OFF;

SET verify on heading on;
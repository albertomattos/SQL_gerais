CREATE OR REPLACE PROCEDURE DROP_TEMP_TABLES_AGFA
IS
-- **************************************************************
-- * 			Agfa Database Services
-- * 			 cristiano.torres@agfa.com
-- * 			   www.agfa.com
-- *
-- * AUTOR: Cristiano Torres
-- * DATA.: 13-04-2011 (Ultima Atualizacao)
-- *
-- * FINALIDADE: Realiza limpeza das tabelas temporaria geradas
-- * diariamente pelo sistema AGFA.
-- *
-- **************************************************************
ncount     NUMBER;
f_id	   VARCHAR2(500);
IN_USE_EXCEPTION_WAIT EXCEPTION;
PRAGMA EXCEPTION_INIT(IN_USE_EXCEPTION_WAIT, -54);

IN_USE_EXCEPTION_TABLE EXCEPTION;
PRAGMA EXCEPTION_INIT(IN_USE_EXCEPTION_TABLE, -942);

IN_USE_EXCEPTION_RESIZE EXCEPTION;
PRAGMA EXCEPTION_INIT(IN_USE_EXCEPTION_RESIZE, -3297);

BEGIN

   FOR REG IN (SELECT TABLE_NAME,OWNER
               FROM DBA_TABLES
				WHERE (owner in ('WPD') or (
				owner in ('ADMWPD') and
				substr(table_name,length(table_name),1) in ('0','1','2','3','4','5','6','7','8','9') and
				substr(table_name,length(table_name)-1,1) in ('0','1','2','3','4','5','6','7','8','9') and
				substr(table_name,length(table_name)-2,1) in ('0','1','2','3','4','5','6','7','8','9'))) and
				table_name not like 'CBOS_2002'
	) LOOP

   BEGIN
	   EXECUTE IMMEDIATE 'DROP TABLE '||reg.owner||'.'||reg.table_name||' PURGE';

    EXCEPTION
    WHEN IN_USE_EXCEPTION_WAIT THEN
     NULL;
    WHEN IN_USE_EXCEPTION_TABLE THEN
     NULL;
   WHEN IN_USE_EXCEPTION_RESIZE THEN
     NULL;
   END;
   END LOOP;

	EXECUTE IMMEDIATE 'purge dba_recyclebin';

END;
/

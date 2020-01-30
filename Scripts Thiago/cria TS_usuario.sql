----------------------
---CRIANDO TABLESPACE
----------------------


CREATE TABLESPACE "EARJ" 
    LOGGING 
    DATAFILE 'D:\ORACLE\ORADATA\ORCL\EARJ.ora' SIZE 100M 
    AUTOEXTEND 
    ON NEXT  100M MAXSIZE  300M EXTENT MANAGEMENT LOCAL


ALTER TABLESPACE VARCO 
    ADD 
    DATAFILE '/oracle/oradata/orcl/v.dbf' SIZE 5M AUTOEXTEND 
    ON NEXT  100M MAXSIZE  1000M

----------------------
---CRIANDO USUÁRIO
----------------------


CREATE USER "EARJ"  PROFILE "DEFAULT" 
    IDENTIFIED BY "earj" DEFAULT TABLESPACE "EARJ" 
    TEMPORARY TABLESPACE "MXMTMP" 
    QUOTA UNLIMITED 
    ON "EARJ" 
    QUOTA UNLIMITED 
    ON "MXMTMP" 
    ACCOUNT UNLOCK;
GRANT "CONNECT" TO "EARJ";
GRANT "MXMDBA" TO "EARJ";
GRANT "MXMSYS" TO "EARJ";


----------------------
---CRIANDO ROLE
----------------------


create role mxmsys identified by mxmsys

----------------------
---ALTERANDO SENHA 
----------------------

alter user NOME identified by NOME

----------------------
---CRIANDO CHAVE ESTRANGEIRA
----------------------

ALTER TABLE TI_MAPGERAL_TMG ADD CONSTRAINT TI_MAPGERAL_TMG_FK1
FOREIGN KEY (TMG_CDSISTEMA)
REFERENCES TI_SIORIGEM_TSO (TSO_CDSISTEMA) ;

----------------------
---CRIANDO CHAVE PRIMARIA
----------------------
ALTER TABLE TI_MAPGERAL_TMG ADD CONSTRAINT TI_MAPGERAL_TMG_PK
PRIMARY KEY (TMG_CDSISTEMA , TMG_CDMAPEAMENTO , TMG_CDORIGEM) 
USING INDEX TABLESPACE MXMIDAD;


----------------------
---CRIANDO SYNONYM PUBLIC 
----------------------
CREATE PUBLIC SYNONYM SEQ_REQCOMPRA FOR SEQ_REQCOMPRA


----------------------
---definindo quotas
----------------------

alter user USUARIO quota unlimited on TABLESPCAE

----------------------
---PREVILEGIOS
----------------------

GRANT MXMDBA. MXMSYS TO USUARIO


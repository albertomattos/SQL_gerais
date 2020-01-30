SET ECHO ON
SET PAGESIZE 1000

/* -------------------------------------------------------------------- */
/* Script MXM00 - Cria ambiente do da mxm informatica                   */
/* devera ser rodado no servidor. Verifique se o diretório              */
/* onde serao criadas as tablespaces existem. Inicialmente todas        */
/* as tablespaces serão criadas no diretório c:\orant\dados\ ,          */
/* mas isso NÃO É A MELHOR OPÇÃO                                        */
/* no caso do personal, criar este diretório                           */ 
/* observações importantes:                                            */
/* - A tablespace de dados (mxmdad) deve estar, se possível, em um disco*/
/*   separado da tablespace de índices (mxmidad).                       */
/* - A tablespace temporária (mxmtmp), sempre que possível,  deverá estar*/
/*   em disco diferente da tablespace de índices.                        */
/* - A Tablespace de rollback (mxmrbs), sempre que possível, deverá estar */
/*     em disco diferente da tablespace de dados (mxmdad).               */

/* Exemplo :                                                             */
/*     d:\orant\dados\mxmtmp                                             */
/*     d:\orant\dados\mxmdad                                             */
/*     c:\orant\dados\mxmidad                                            */
/*     c:\orant\dados\mxmrbs                                             */


 SPOOL D:\orant\dados\MXM00.log

connect system/manager

/* --------------------------------------------------------------------- */
/*  Criação de Tablespace para Alocação de Dados.                        */
/* --------------------------------------------------------------------- */

/* PARA COLOCAR A TABLESPACE SYSTEM COMO UNLIMITED AUMENTANDO 10M POR VEZ*/

ALTER DATABASE 
  DATAFILE 'D:\ORANT\DATABASE\SYS1ORCL.ORA' 
   AUTOEXTEND ON 
   NEXT 10M MAXSIZE UNLIMITED;

CREATE TABLESPACE MXMDAD 
DATAFILE 'D:\ORANT\DADOS\MXMDAD' SIZE 10M 
AUTOEXTEND ON NEXT 10M
ONLINE;

CREATE TABLESPACE MXMIDAD 
DATAFILE 'D:\ORANT\DADOS\MXMIDAD' SIZE 10M 
AUTOEXTEND ON NEXT 10M
ONLINE;

CREATE TABLESPACE MXMTMP 
DATAFILE 'D:\ORANT\DADOS\MXMTMP' SIZE 10M 
AUTOEXTEND ON NEXT 10M 
TEMPORARY
ONLINE;

CREATE TABLESPACE MXMRBS DATAFILE 
'D:\ORANT\DADOS\MXMRBS' SIZE 10M 
AUTOEXTEND ON NEXT 10M
ONLINE;

/* Criacao das areas de rollback                                       */

CREATE PUBLIC ROLLBACK SEGMENT MXMRBS001
       TABLESPACE MXMRBS
       STORAGE (INITIAL     2M
                NEXT        2M
                MINEXTENTS   2
                MAXEXTENTS 121)
;

CREATE PUBLIC ROLLBACK SEGMENT MXMRBS002
       TABLESPACE MXMRBS
       STORAGE (INITIAL    100K 
                NEXT       100K
                MINEXTENTS   2
                MAXEXTENTS 121)
;



ALTER ROLLBACK SEGMENT MXMRBS001 ONLINE;
ALTER ROLLBACK SEGMENT MXMRBS002 ONLINE;

/* -------------------------------------------------------------------- */
/*                       Criação dos Usuários.                          */
/* -------------------------------------------------------------------- */

create user manager identified by manager 
DEFAULT TABLESPACE MXMDAD
TEMPORARY TABLESPACE MXMTMP;

create user mxmcomum identified by mxmcomum 
DEFAULT TABLESPACE MXMDAD
TEMPORARY TABLESPACE MXMTMP;

-- PARA CRIAR VÁRIOS USUÁRIO TROQUE ****** POR OUTRO NOME
-- create user ****** identified by ******
-- DEFAULT TABLESPACE MXMDAD
-- TEMPORARY TABLESPACE MXMTMP;


grant CONNECT,RESOURCE,DBA to manager,mxmcomum ;
grant UNLIMITED TABLESPACE to manager,mxmcomum ;

-- PARA CRIAR VÁRIOS USUÁRIO TROQUE ****** POR OUTRO NOME
--grant CONNECT,RESOURCE,DBA to ******;
--grant UNLIMITED TABLESPACE to ******;

/* Alteracao das tablespaces default dos usuarios */
ALTER USER MANAGER  DEFAULT ROLE DBA;
ALTER USER MXMCOMUM DEFAULT ROLE DBA;

-- PARA CRIAR VÁRIOS USUÁRIO TROQUE ****** POR OUTRO NOME
--ALTER USER ****** DEFAULT ROLE DBA;

/* Criacao das Roles para as rotinas de segurança  */

CREATE ROLE MXMSYS IDENTIFIED BY MXMSYS;
CREATE ROLE MXMDBA IDENTIFIED BY MXMDBA;

GRANT DBA TO MXMSYS,MXMDBA;

/* Atribuicao dos direitos das roles aos usuarios */

GRANT MXMSYS,MXMDBA TO MANAGER,MXMCOMUM;
-- PARA CRIAR VÁRIOS USUÁRIO TROQUE ****** POR OUTRO NOME
GRANT MXMSYS,MXMDBA TO ******;
SPOOL OFF;


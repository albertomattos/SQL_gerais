SET ECHO ON
SET PAGESIZE 1000

/* --------------------------------------------------------------------   */
/* Script MXM00 - Cria ambiente do da mxm informatica                     */
/* devera ser rodado no servidor. Verifique se o diret�rio                */
/* onde serao criadas as tablespaces existem. Inicialmente todas          */
/* as tablespaces ser�o criadas no diret�rio c:\orant\dados\ ,            */
/* mas isso N�O � A MELHOR OP��O                                          */
/* no caso do personal, criar este diret�rio                              */ 
/* observa��es importantes:                                               */
/* - A tablespace de dados (mxmdad) deve estar, se poss�vel, em um disco  */
/*   separado da tablespace de �ndices (mxmidad).                         */
/* - A tablespace tempor�ria (mxmtmp), sempre que poss�vel,  dever� estar */
/*   em disco diferente da tablespace de �ndices.                         */
/* - A Tablespace de rollback (mxmrbs), sempre que poss�vel, dever� estar */
/*     em disco diferente da tablespace de dados (mxmdad).                */

/* Exemplo :                                                              */
/*     d:\orant\dados\mxmtmp                                              */
/*     d:\orant\dados\mxmdad                                              */
/*     c:\orant\dados\mxmidad                                             */
/*     c:\orant\dados\mxmrbs                                              */

/* mudar de acordo com o diretorio do oracle no servidor*/

SPOOL d:\orant\dados\MXM00_TESTE.log

connect system/MANAGER

/* ---------------------------------------------------------------------- */
/*                       Cria��o dos Usu�rios.                            */
/* ---------------------------------------------------------------------- */

create user TESTE identified by TESTE ;
grant CONNECT,RESOURCE,DBA to TESTE ;
grant UNLIMITED TABLESPACE to TESTE ;

create user CONSULTOR identified by mxm;
grant dba to CONSULTOR;
grant unlimited tablespace to CONSULTOR;


/* Alteracao das tablespaces default dos usuarios */


ALTER USER TESTE 
DEFAULT TABLESPACE MXMDAD
TEMPORARY TABLESPACE MXMTMP;


/* Atribuicao dos direitos das roles aos usuarios */

GRANT MXMSYS,MXMDBA TO TESTE;
grant dba to mxmsys;
grant mxmsys,mxmdba to CONSULTOR;

SPOOL OFF                   
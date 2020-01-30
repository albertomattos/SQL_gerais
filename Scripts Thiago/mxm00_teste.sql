SET ECHO ON
SET PAGESIZE 1000

/* --------------------------------------------------------------------   */
/* Script MXM00 - Cria ambiente do da mxm informatica                     */
/* devera ser rodado no servidor. Verifique se o diretório                */
/* onde serao criadas as tablespaces existem. Inicialmente todas          */
/* as tablespaces serão criadas no diretório c:\orant\dados\ ,            */
/* mas isso NÃO É A MELHOR OPÇÃO                                          */
/* no caso do personal, criar este diretório                              */ 
/* observações importantes:                                               */
/* - A tablespace de dados (mxmdad) deve estar, se possível, em um disco  */
/*   separado da tablespace de índices (mxmidad).                         */
/* - A tablespace temporária (mxmtmp), sempre que possível,  deverá estar */
/*   em disco diferente da tablespace de índices.                         */
/* - A Tablespace de rollback (mxmrbs), sempre que possível, deverá estar */
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
/*                       Criação dos Usuários.                            */
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
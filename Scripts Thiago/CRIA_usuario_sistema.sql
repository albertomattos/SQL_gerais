ACCEPT usuario PROMPT 'Nome do usuario: '
 

insert into 
GRUPOTRABALHO_GRT 
values(
-1,
'GRUPO GERAL',
UPPER('&usuario'),     
SYSDATE,
NULL,
NULL,
NULL)
/
 
INSERT INTO USUARIO_USO
 (USO_CODIGO,
  USO_NOME,
  USO_ESTRFUNCIONAL,
  USO_GRP_TRABALHO,
  USO_CRIADOPORMXM,
  USO_TIPEMAIL,
  USO_ENDEMAIL,
  USO_CDCRIADOR,
  USO_DTCRIACAO,
  USO_CDHOMOLOGADOR,
  USO_DTHOMOLOGACAO,
  USO_IDIOMA
) 
VALUES(
UPPER('&usuario'),
UPPER('&usuario'),
  'N', 
  '-1',
  'N',
  NULL,
  NULL,
  'MXM',
  SYSDATE,
  NULL,
  NULL,
  'PTB'
);
COMMIT;
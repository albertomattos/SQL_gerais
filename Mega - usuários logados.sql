update MGGLO.GLO_LOGACESSOSISTEMA
set USU_DT_LOGOUT = SYSDATE
where USU_DT_LOGOUT is null
--and usu_st_enderecoip = '172.20.20.12'
and usu_dt_login <= '15/05/2018'

-- Somente usu�rios com atividade nos �ltimos XX minutos
SELECT USU_IN_CODIGO, GRU_ST_NOME, USU_ST_ENDERECOIP
FROM MGGLO.GLO_LOGACESSOSISTEMA LOG, MGGLO.GLO_GRUPO_USUARIO USU
WHERE USU.GRU_IN_CODIGO = LOG.USU_IN_CODIGO AND USU_DT_LOGIN = TRUNC(SYSDATE) AND USU_DT_LOGOUT IS NULL
AND ((SYSDATE - USU_DT_ULTACESSO) * 1440) < 60
GROUP BY USU_IN_CODIGO, GRU_ST_NOME, USU_ST_ENDERECOIP ORDER BY GRU_ST_NOME, USU_ST_ENDERECOIP

select distinct usu_st_enderecoip from MGGLO.GLO_LOGACESSOSISTEMA
where USU_DT_LOGOUT is null
select * from MGGLO.GLO_LOGACESSOSISTEMA
where USU_DT_LOGOUT is null

--and usu_st_enderecoip = '172.20.24.1'
and usu_dt_login <= '19/11/2012'

select * from mgglo.glo_usu_logados
insert into glo_usu_logados values (
(select distinct usu_st_enderecoip from MGGLO.GLO_LOGACESSOSISTEMA where USU_DT_LOGOUT is null),'1')

create table glo_usu_logados (enderecoip varchar2(20) primary key, usuariologado varchar2(20))
select t.*, t.rowid from glo_usu_logados t
commit;

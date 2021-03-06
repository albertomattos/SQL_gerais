
/*
SELECT l.usu_dt_login, l.usu_dt_logout, l.usu_dt_ultacesso, u.gru_st_nome, l.*
FROM MGGLO.GLO_LOGACESSOSISTEMA L, MGGLO.GLO_GRUPO_USUARIO U
WHERE U.GRU_IN_CODIGO = L.USU_IN_CODIGO AND u.gru_st_nome = 'barbara'
order by 1, gru_st_nome

select * from MGGLO.GLO_LOGACESSOSISTEMA where  usu_in_codigo = '133' order by 1 desc

select * from MGGLO.GLO_GRUPO_USUARIO
*/

select count(distinct t.usu_st_enderecoip)
from MGGLO.GLO_LOGACESSOSISTEMA t, mgglo.glo_grupo_usuario u
where USU_DT_LOGOUT is null and to_char(usu_dt_login, 'dd/mm/yyyy') = '09/05/2018'
and t.usu_in_codigo = u.gru_in_codigo
/*
select t.usu_st_enderecoip,t.sis_in_codigo,u.gru_st_nomecompleto,t.usu_dt_ultacesso, t.usu_dt_logout, t.rowid
from MGGLO.GLO_LOGACESSOSISTEMA t, mgglo.glo_grupo_usuario u
where USU_DT_LOGOUT is null --and t.sis_in_codigo <> '1'
  and to_char(usu_dt_login, 'dd/mm/yyyy') = '16/05/2017'
and t.usu_in_codigo = u.gru_in_codigo
order by 3
*/

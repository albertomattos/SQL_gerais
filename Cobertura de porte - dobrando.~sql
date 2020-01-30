select b.fantasia, c.nome_plano, a.cod_tipo, a.tab_int, a.acres_int
from faccgcad a, faconcad b, faplacad c where a.cod_con = b.cod_con
and a.cod_pla = c.cod_pla and b.cod_con = c.cod_con and a.tipo_prd = 'PRO'
and a.cod_con = '010'
and b.fantasia like 'PETR%' order by 1,2

select a.*, a.rowid
from faccgcad a, faconcad b, faplacad c where a.cod_con = b.cod_con
and a.cod_pla = c.cod_pla and b.cod_con = c.cod_con and a.tipo_prd = 'PRO'/* and a.cod_con = '010' and a.cod_tipo = ' '*/
order by 5 desc, 1
and b.fantasia like 'CASF%' order by 1,2

select 	USERNAME,	CREATED, PROFILE,	DEFAULT_TABLESPACE,	TEMPORARY_TABLESPACE from dba_users order by 4

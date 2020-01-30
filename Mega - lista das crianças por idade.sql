select distinct(t.pes_st_nome) paimae, u.ben_st_nome filho, u.ben_dt_nascimento
from mgrh.rh_pessoa t, mgrh.rh_rel_colaborador b, mgrh.rh_colaborador c,
mgrh.rh_beneficiario u
where t.pes_in_codigo = u.pes_in_codigo
and b.col_in_codigo = c.col_in_codigo
and c.pes_in_codigo = t.pes_in_codigo
and b.rcol_bo_emrescisao = 'N'
and u.ben_dt_nascimento > '01/01/2005' --8 anos
and u.tpb_in_codigo = '1'
and b.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
order by 1
/* select * from mgrh.rh_beneficiario
select * from mgrh.rh_pessoa where pes_st_nome like 'ANDRESSA NUNES%'
select * from mgrh.rh_colaborador where pes_in_codigo = '7511'
select * from mgrh.rh_rel_colaborador where col_in_codigo = '4651'*/

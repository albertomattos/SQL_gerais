select distinct(t.pes_st_nome) from mgrh.rh_pessoa t, mgrh.rh_rel_colaborador b, mgrh.rh_colaborador c,
mgrh.rh_beneficiario u
where t.pes_in_codigo = u.pes_in_codigo
and b.col_in_codigo = c.col_in_codigo
and c.pes_in_codigo = t.pes_in_codigo
and t.pes_ch_sexo = 'F'
and b.rcol_bo_emrescisao = 'N'
--or v.adm_dt_admissao > '01/04/2013'
and u.tpb_in_codigo = '1'
and b.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
union
/*
select * from mgrh.rh_pessoa where pes_st_nome like 'ANDRESSA NUNES%'
select * from mgrh.rh_colaborador where pes_in_codigo = '7511'
select * from mgrh.rh_rel_colaborador where col_in_codigo = '4651'*/
select  distinct(a.pes_st_nome) from mgrh.rh_pessoa a, mgrh.rh_admissao b, mgrh.rh_colaborador c,
mgrh.rh_beneficiario d
where a.pes_in_codigo = d.pes_in_codigo and a.pes_in_codigo = c.pes_in_codigo
and c.col_in_codigo = b.col_in_codigo
--and b.adm_dt_admissao >= '01/05/2013'
and a.pes_ch_sexo = 'F' and d.tpb_in_codigo = '1'
order by 1

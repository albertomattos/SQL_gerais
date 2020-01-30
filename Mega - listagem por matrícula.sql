select c.adm_st_matricula, b.pes_st_nome--, c.adm_dt_admissao
from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgrh.rh_admissao c, mgrh.rh_rel_colaborador f
where a.pes_in_codigo = b.pes_in_codigo
and a.col_in_codigo = c.col_in_codigo
and a.col_in_codigo = f.col_in_codigo
and b.pes_in_codigo = f.pes_in_codigo
--and f.rcol_bo_emrescisao = 'N'
--and a.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
--and a.pes_in_codigo = '1652'
and b.pes_st_nome like 'JAMES%'
group by c.adm_st_matricula, b.pes_st_nome, c.adm_dt_admissao, b.pes_st_numpis, b.pes_st_cpf
order by c.adm_st_matricula

--select * from mgrh.rh_rel_colaborador

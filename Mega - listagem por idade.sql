select c.adm_st_matricula matricula, g.cus_st_descricao centrodecusto, b.pes_st_nome nome, b.pes_dt_nascimento nascimento
from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgrh.rh_admissao c, mgrh.rh_rel_colaborador f, mgcon.con_centro_custo g,
mgrh.rh_hist_projeto h
where a.pes_in_codigo = b.pes_in_codigo
and a.col_in_codigo = c.col_in_codigo and a.col_in_codigo = f.col_in_codigo
and b.pes_in_codigo = f.pes_in_codigo and g.cus_in_reduzido = f.cus_in_reduzido
and h.cus_in_reduzido = g.cus_in_reduzido
and h.col_in_codigo = a.col_in_codigo and f.rcol_bo_emrescisao = 'N'
and a.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
and h.hpro_dt_inicio=(select max(h2.hpro_dt_inicio) from mgrh.rh_hist_projeto h2 where h.col_in_codigo = h2.col_in_codigo)
--and g.cus_st_descricao like 'TECNOLOGIA%'
group by c.col_in_codigo, c.adm_st_matricula, b.pes_st_nome, c.adm_dt_admissao, b.pes_st_numpis, b.pes_st_cpf, b.pes_dt_nascimento,
g.cus_st_descricao, h.hpro_dt_inicio
order by g.cus_st_descricao, c.adm_st_matricula

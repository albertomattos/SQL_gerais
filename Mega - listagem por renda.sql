select b.pes_st_nome, h.hsa_re_valor, h.hsa_dt_inicio, b.pes_st_cpf, b.pes_st_telefone, b.pes_st_celular, c.adm_dt_admissao
from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgrh.rh_admissao c,
     mgrh.rh_rel_colaborador f, mgcon.con_centro_custo g, mgrh.rh_hist_salario h
where a.pes_in_codigo = b.pes_in_codigo
and a.col_in_codigo = c.col_in_codigo
and a.col_in_codigo = f.col_in_codigo
and b.pes_in_codigo = f.pes_in_codigo
and g.cus_in_reduzido = f.cus_in_reduzido
and a.col_in_codigo = h.col_in_codigo
and f.rcol_bo_emrescisao = 'N'
and a.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
and h.hsa_dt_inicio=(select max(h2.hsa_dt_inicio) from rh_hist_salario h2 where h.col_in_codigo = h2.col_in_codigo)
and g.cus_st_descricao like 'TECNO%'
--and b.pes_st_nome like 'NELSON%'
group by b.pes_st_nome, h.hsa_re_valor, h.hsa_dt_inicio, b.pes_st_cpf, b.pes_st_telefone, b.pes_st_celular, c.adm_dt_admissao
order by b.pes_st_nome, h.hsa_dt_inicio desc

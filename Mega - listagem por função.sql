select distinct g.cus_st_descricao, c.adm_st_matricula, b.pes_st_nome, c.adm_dt_admissao, b.pes_st_numpis, b.pes_st_cpf,
       d.fca_st_descricao, f.hjor_dt_inicio
from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgrh.rh_admissao c, mgrh.rh_funcao d, mgrh.rh_hist_funcao e,
     mgrh.rh_rel_colaborador f, mgcon.con_centro_custo g
where a.pes_in_codigo = b.pes_in_codigo
and a.col_in_codigo = c.col_in_codigo
and a.col_in_codigo = e.col_in_codigo
and a.col_in_codigo = f.col_in_codigo
and b.pes_in_codigo = f.pes_in_codigo
and e.fca_in_codigo = d.fca_in_codigo
and e.fca_in_codigo = f.fca_in_codigo
and g.cus_in_reduzido = f.cus_in_reduzido
and f.rcol_bo_emrescisao = 'N'
and a.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
and b.pes_st_nome like 'NELSON%'
--and a.pes_in_codigo = '1652'
--group by g.cus_st_descricao,c.adm_st_matricula, b.pes_st_nome, c.adm_dt_admissao, b.pes_st_numpis, b.pes_st_cpf,
  --    d.fca_st_descricao
--order by g.cus_st_descricao, b.pes_st_nome
order by b.pes_st_nome

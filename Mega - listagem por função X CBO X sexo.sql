select d.fca_st_descricao, c.adm_st_matricula, b.pes_st_nome,  b.pes_ch_sexo, i.cbo_st_codigopadrao, i.cbo_st_descricao
from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgrh.rh_admissao c, mgrh.rh_funcao d, mgrh.rh_hist_funcao e,
     mgrh.rh_rel_colaborador f, mgcon.con_centro_custo g, mgrh.rh_hist_projeto h, mgrh.rh_cbo i, mgrh.rh_funcaocbo j
where a.pes_in_codigo = b.pes_in_codigo
and a.col_in_codigo = c.col_in_codigo and a.col_in_codigo = e.col_in_codigo and a.col_in_codigo = f.col_in_codigo
and b.pes_in_codigo = f.pes_in_codigo and e.fca_in_codigo = d.fca_in_codigo and e.fca_in_codigo = f.fca_in_codigo
and h.col_in_codigo = a.col_in_codigo and f.cbo_in_codigo = i.cbo_in_codigo and i.cbo_in_codigo = j.cbo_in_codigo
and f.fca_in_codigo = j.fca_in_codigo
and g.cus_in_reduzido = f.cus_in_reduzido and f.rcol_bo_emrescisao = 'N'
and a.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
and e.hfc_dt_inicio=(select max(e2.hfc_dt_inicio) from mgrh.rh_hist_funcao e2 where e.col_in_codigo = e2.col_in_codigo)
and h.hpro_dt_inicio=(select max(h2.hpro_dt_inicio) from mgrh.rh_hist_projeto h2 where h.col_in_codigo = h2.col_in_codigo)
group by d.fca_st_descricao, c.adm_st_matricula, b.pes_st_nome,  b.pes_ch_sexo, i.cbo_st_codigopadrao, i.cbo_st_descricao
order by d.fca_st_descricao, b.pes_st_nome

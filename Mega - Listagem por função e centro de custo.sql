select distinct g.cus_st_descricao centro_custo, c.adm_st_matricula matr, b.pes_st_nome colaborador, c.adm_dt_admissao admissao,
       d.fca_st_descricao funcao, e.hfc_dt_inicio, h.res_dt_rescisao
from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgrh.rh_admissao c, mgrh.rh_funcao d, mgrh.rh_hist_funcao e,
     mgrh.rh_rel_colaborador f, mgcon.con_centro_custo g, mgrh.rh_rescisao h
where a.pes_in_codigo = b.pes_in_codigo
and a.col_in_codigo = c.col_in_codigo and a.col_in_codigo = e.col_in_codigo and a.col_in_codigo = f.col_in_codigo
and b.pes_in_codigo = f.pes_in_codigo and e.fca_in_codigo = d.fca_in_codigo and e.fca_in_codigo = f.fca_in_codigo
and g.cus_in_reduzido = f.cus_in_reduzido and a.col_in_codigo = h.col_in_codigo(+)
and e.hfc_dt_inicio = (SELECT max(HFF.hfc_dt_inicio) FROM mgrh.RH_HIST_FUNCAO HFF WHERE HFF.COL_IN_CODIGO = e.col_in_codigo  )
--and f.rcol_bo_emrescisao = 'N'
and a.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
and b.pes_st_nome like 'ROSANE %'
order by b.pes_st_nome

select c.adm_st_matricula, b.pes_st_nome NOME, fu.fca_st_descricao FUNCAO, round(h.hsa_re_valor,2) SALARIO, e.orf_st_descricao
  from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgrh.rh_admissao c, mgrh.rh_hist_organograma d, mgglo.glo_organofunc e,
       mgrh.RH_HIST_FUNCAO HF, mgrh.RH_FUNCAO FU, mgrh.rh_hist_salario h, mgcon.con_centro_custo t
  where a.pes_in_codigo = b.pes_in_codigo
        and a.col_in_codigo = c.col_in_codigo
        and a.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
        and a.col_in_codigo = d.col_in_codigo
        and d.orf_in_reduzido = e.orf_in_reduzido
        and a.col_in_codigo = hf.col_in_codigo
        and hf.hfc_dt_inicio = (SELECT max(HFF.hfc_dt_inicio) FROM mgrh.RH_HIST_FUNCAO HFF WHERE HFF.COL_IN_CODIGO = hf.col_in_codigo  )
        and hf.fca_in_codigo = fu.fca_in_codigo
        and a.col_in_codigo = h.col_in_codigo
        and h.hsa_dt_inicio=(select max(h2.hsa_dt_inicio) from mgrh.rh_hist_salario h2 where h.col_in_codigo = h2.col_in_codigo)
        and d.hor_dt_inicio=(select max(d2.hor_dt_inicio) from mgrh.rh_hist_organograma d2 where d.col_in_codigo = d2.col_in_codigo)
--        and b.pes_st_nome like 'LUANA%'
        and e.orf_st_descricao like 'TECNOL%'
GROUP BY c.adm_st_matricula, b.pes_st_nome, fu.fca_st_descricao, h.hsa_re_valor, e.orf_st_descricao
ORDER BY b.pes_st_nome;

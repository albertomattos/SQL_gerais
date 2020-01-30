select b.pes_st_nome, u.orf_st_descricao localizacao, fu.fca_st_descricao FUNCAO,
       to_char(c.adm_dt_admissao, 'dd/mm/yyyy') "DATA DE ADMISSAO"
  from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgrh.rh_admissao c, MGGLO.GLO_PESSOA_FISICA g,
       mgrh.RH_HIST_FUNCAO HF, mgrh.RH_FUNCAO FU, mgrh.rh_hist_organograma t, mgglo.glo_organofunc u
  where a.pes_in_codigo = b.pes_in_codigo
        and a.col_in_codigo = c.col_in_codigo
        and a.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
        and t.orf_in_reduzido = u.orf_in_reduzido
        and a.col_in_codigo = t.col_in_codigo
--and b.pes_st_nome LIKE 'NEL%'
        and a.col_in_codigo = hf.col_in_codigo
        and hf.hfc_dt_inicio = (SELECT max(HFF.hfc_dt_inicio) FROM mgrh.RH_HIST_FUNCAO HFF WHERE HFF.COL_IN_CODIGO = hf.col_in_codigo  )
        and hf.fca_in_codigo = fu.fca_in_codigo
        and t.hor_dt_inicio=(select max(t2.hor_dt_inicio) from  mgrh.rh_hist_organograma t2 where t.col_in_codigo = t2.col_in_codigo)
        AND G.AGN_ST_CPF = B.pes_st_cpf
        and g.agn_dt_admissao=(select max(g2.agn_dt_admissao) from  mgglo.GLO_PESSOA_FISICA g2 where g.agn_st_cpf = g2.agn_st_cpf)
GROUP BY b.pes_st_nome, u.orf_st_descricao, fu.fca_st_descricao, to_char(c.adm_dt_admissao, 'dd/mm/yyyy')
ORDER BY 2,1;

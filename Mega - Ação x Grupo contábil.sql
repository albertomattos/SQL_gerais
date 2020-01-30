select t.*, u.*, v.* from mgglo.glo_acao t, mgglo.glo_acaoprocessorh u, mgcon.con_plano_conta v
where t.acao_in_codigo = u.acao_in_codigo
and v.pla_in_reduzido = u.cre_in_reduzido
and t.acao_st_tipo = 'FOLHA'

select distinct(t.pes_st_nome) from mgrh.rh_pessoa t, mgrh.rh_rel_colaborador b, mgrh.rh_colaborador c, mgrh.rh_beneficiario u
where t.pes_in_codigo = u.pes_in_codigo
and b.col_in_codigo = c.col_in_codigo
and c.pes_in_codigo = t.pes_in_codigo
and t.pes_ch_sexo = 'M'
and b.rcol_bo_emrescisao = 'N'
and u.tpb_in_codigo = '1'
and b.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)

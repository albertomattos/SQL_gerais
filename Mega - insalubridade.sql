select g.cus_st_descricao, c.adm_st_matricula, b.pes_st_nome, d.comp_dt_inicio, d.comp_re_valor
from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgrh.rh_admissao c, mgrh.rh_rel_colaborador f, mgrh.rh_complementoauxiliar d,
mgcon.con_centro_custo g, MGRH.RH_HIST_ORGANOGRAMA HO
where a.pes_in_codigo = b.pes_in_codigo
and a.col_in_codigo = c.col_in_codigo
and a.col_in_codigo = f.col_in_codigo
and b.pes_in_codigo = f.pes_in_codigo
and a.col_in_codigo = d.col_in_codigo
and F.ORF_IN_REDUZIDO = HO.ORF_IN_REDUZIDO
AND D.COL_IN_CODIGO = HO.COL_IN_CODIGO
and f.cus_in_reduzido = g.cus_in_reduzido
and f.rcol_bo_emrescisao = 'N'
and a.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
and HO.hor_dt_inicio=(select max(H2.hor_dt_inicio) from MGRH.RH_HIST_ORGANOGRAMA H2 where H2.COL_in_codigo = HO.COL_in_codigo)
and d.caux_in_sequencia = '3'
and d.comp_dt_final is null
and c.adm_st_matricula = '000280'
group by g.cus_st_descricao, c.adm_st_matricula, b.pes_st_nome, d.comp_dt_inicio, d.comp_re_valor
order by g.cus_st_descricao, b.pes_st_nome

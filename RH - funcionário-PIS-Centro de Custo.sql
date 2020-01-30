select a.pes_st_nome, d.adm_st_matricula, a.pes_st_numpis, b.cus_st_descricao
from mgrh.rh_pessoa a, mgcon.con_centro_custo b, mgrh.rh_hist_projeto c, mgrh.rh_admissao d
where a.pes_in_codigo = d.adm_st_chapeira
and c.col_in_codigo = d.col_in_codigo
and b.cus_in_reduzido = c.cus_in_reduzido
and c.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
order by a.pes_st_nome

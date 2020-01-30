select t.end_dt_inicio, u.pes_st_nome, t.tpl_st_sigla, t.end_st_endereco, t.end_in_numero, t.end_st_complemento,
t.end_st_bairro, t.end_st_cep
from mgrh.rh_endereco t, mgrh.rh_pessoa u, mgrh.rh_rel_colaborador b, mgrh.rh_colaborador c
where t.pes_in_codigo = u.pes_in_codigo
and c.pes_in_codigo = u.pes_in_codigo
and b.col_in_codigo = c.col_in_codigo
and b.rcol_bo_emrescisao = 'N'
order by u.pes_st_nome

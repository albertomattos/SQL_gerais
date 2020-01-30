select t.*, u.descricao, t.rowid from esprod_set_lote t, faprdcad u
where t.cod_prd = u.codigo
and u.codigo = '234469'
--and t.cod_set = '0089'
order by u.descricao

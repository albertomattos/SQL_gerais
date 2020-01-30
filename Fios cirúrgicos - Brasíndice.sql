select t.descricao, t.cod_bras, t.uni_compra, t.divisor, u.preco, u.uni_compra, t.rowid from faprdcad t, braswpd u
where t.cod_bras_tiss = u.cod_bras_tiss
and t.codigo = '048861'

select t.codigo, t.descricao, t.cod_bras, t.uni_compra, t.divisor, u.uni_compra, t.rowid from faprdcad t, braswpd u
where t.cod_bras_tiss = u.cod_bras_tiss
and t.tipo_prd = 'FIO' --and u.uni_compra not like '%DZ%'
order by t.codigo

select t.codigo, t.descricao, t.cod_bras, t.uni_compra, t.divisor, t.rowid from faprdcad t
where t.cod_bras_tiss not in (select cod_bras_tiss from braswpd)
and t.tipo_prd = 'FIO'
order by t.codigo

select t.codigo, t.descricao, t.cod_bras, t.uni_compra, t.divisor, t.rowid from faprdcad t
where t.cod_bras_tiss is null
and t.tipo_prd = 'FIO'
order by t.codigo

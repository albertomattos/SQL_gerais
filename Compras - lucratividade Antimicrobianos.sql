select t.codigo, t.descricao, round(t.custo_atu,2) custo, t.uni_distri, u.tipo_preco, u.preco brasindice,
t.divisor,round((u.preco/t.divisor),2) venda,
u.uni_compra, t.ult_compra, t.cod_bras_tiss
from faprdcad t, braswpd u, escarcad v, escarprd x
where t.cod_bras_tiss = u.cod_bras_tiss
and x.cod_prd = t.codigo and v.cod_car = x.cod_car
and v.cod_car in ('ANMC','AMTO','AMVA')
and t.tipo_prd = 'MED' and t.ult_compra >= '01/01/2013'
order by t.ult_compra desc
--select * from braswpd where cod_bras_tiss = '0000016131'

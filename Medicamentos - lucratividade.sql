select t.codigo, t.descricao, round(t.custo_atu,2) custo, t.uni_distri, u.preco brasindice, t.divisor,round((u.preco/t.divisor),2) venda,
u.uni_compra, t.ult_compra, t.cod_bras_tiss
from faprdcad t, braswpd u
where t.cod_bras_tiss = u.cod_bras_tiss
and t.tipo_prd = 'MED' and t.ult_compra >= '01/01/2013'
order by t.ult_compra desc

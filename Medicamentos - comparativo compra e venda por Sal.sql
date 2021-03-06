select v.descricao sal, t.codigo, t.descricao produto, round(t.custo_atu,2) custo, t.uni_compra, t.uni_distri, u.preco brasindice, t.divisor,round((u.preco/t.divisor),2) venda,
t.ult_compra
from faprdcad t, braswpd u, essalcad v, essalprd w
where t.cod_bras_tiss = u.cod_bras_tiss and t.codigo = w.cod_prd and w.cod_sal = v.cod_sal
and t.bloqueado = 'N' and t.tipo_prd in ('MED','MQU')
order by 1,2

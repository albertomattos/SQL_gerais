select a.codigo, b.tabela, c.descricao, b.valor, b.valor_sub, a.descricao, a.tipo_prd, a.uni_compra, a.uni_distri, a.cod_apresent, a.ult_compra,
a.custo_atu, a.ult_atu_bras, a.divisor, a.cod_bras, a.cod_bras_tiss, a.co_tuss_bras, a.co_tuss
from faprdcad a, faprecad b, faapetab c where a.codigo = b.codigo and b.tabela = c.tabela
and a.tipo_prd = 'MED' and a.bloqueado = 'N' and c.tipo_prd = 'MED'
and b.validade = '20/02/2015'
order by 6,2

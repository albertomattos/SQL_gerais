select c.tipo_prd, a.codigo, c.descricao, a.valor, b.tabela, b.descricao, c.co_tuss
from faprecad a, faapetab b, faprdcad c
where a.tabela = b.tabela and a.codigo = c.codigo and b.tipo_prd = c.tipo_prd
and b.tipo_prd in ('GMD', 'DIA', 'TAX', 'VID') and a.validade = '25/07/2017'
and c.tipo_prd in ('GMD', 'DIA', 'TAX', 'VID')
order by 1,3

select a.codigo, a.descricao, a.tipo_prd, a.uni_compra, a.uni_distri, a.cod_apresent, a.ult_compra, a.custo_atu,
a.ult_atu_bras, a.divisor, a.cod_simpro, a.co_tuss_simpro, a.co_tuss
from faprdcad a where a.tipo_prd = 'DES' and a.bloqueado = 'N'
order by 2

select p.codigo, r.descricao, r.divisor,
r.custo_atu Custo,
p.valor Unit_sugerido,
p.valor_sub Brasindice_suger
from faprecad p, faprdcad r
where p.codigo = r.codigo and p.validade = "20/07/2004" and p.tabela = "01" order by descricao-- and p.codigo = "005285"

--select codigo, valor, valor_sub from faprecad where codigo = "005285" and validade = "20/07/2004" and tabela = "01" --p
--select codigo, descricao, tipo_prd, divisor, custo_atu from faprdcad where codigo = "005285" --r
--select * from eshiscus where cod_prd = "005285"


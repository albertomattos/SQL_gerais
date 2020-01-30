--select p.codigo, p.descricao, p.tipo_prd, e.tabela, e.validade, e.coef_filme, e.coef_honor, e.custo_oper, e.valor
--from faprdcad p, faprecad e
--where p.codigo = e.codigo and p.tipo_prd = "MED" and tabela = "1"-- and validade = "01/05/2003"

--delete * from faprecad
--where(select p.codigo, p.descricao, p.tipo_prd, e.tabela, e.validade, e.coef_filme, e.coef_honor, e.custo_oper, e.valor
--from faprdcad p, faprecad e
--where p.codigo = e.codigo and p.tipo_prd = "MED" and tabela "1")

--delete from faprecad where tabela = "1"
select * from faprecad where tabela = "1" order by validade
--select * from faprdcad where tipo_prd = "MED"


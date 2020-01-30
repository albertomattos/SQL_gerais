select b.descricao, b.cod_amb, a.tabela, a.coef_honor, c.val_honor from faprecad a, faprdcad b, fafilhon c
where a.codigo = b.codigo and b.tipo_prd = c.tipo_prd and a.tabela = c.tabela and a.validade = c.validade
and a.codigo in (select codigo from faprdcad where tipo_prd = "TOM" and bloqueado = "N")
and a.validade = "01/03/2009"
order by b.descricao, a.tabela

select * from fafilhon where tipo_prd = "RAX" and validade = "01/03/2009"

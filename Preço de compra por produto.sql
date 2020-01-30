select t.tipo_prd, t.codigo, t.descricao, t.custo_atu, t.custo_med, t.ult_compra, t.rowid from faprdcad t
where t.tipo_prd in (select tipo_prd from fatipcad where pre_class = 'MAT' and faturavel = 'S')
and bloqueado = 'N'
order by 1,3

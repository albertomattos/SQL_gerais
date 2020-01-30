select * from faprdcad where tipo_prd in (
select tipo_prd from fatipcad where tem_estoque = 'S' and pre_class = 'MAT' and faturavel = 'N'
and natureza = 'SERVIÇOS')

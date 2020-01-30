select t.tipo_prd, t.codigo, t.descricao, t.custo_med from faprdcad t where t.tipo_prd in
(select tipo_prd from fatipcad where pre_class = 'MAT' and faturavel = 'S')

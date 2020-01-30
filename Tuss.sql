select t.codigo, t.descricao, t.tipo_prd, t.co_tuss from faprdcad t where t.bloqueado = 'N'
and t.tipo_prd in (select tipo_prd from fatipcad where faturavel = 'S') and t.tipo_prd <> 'KIT'
order by t.tipo_prd, t.descricao

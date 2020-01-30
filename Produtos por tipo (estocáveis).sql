select u.tipo_prd, u.descricao, t.codigo, t.descricao from faprdcad t, fatipcad u
where t.tipo_prd = u.tipo_prd
and u.faturavel = 'N' and t.bloqueado = 'N'

--and u.tem_estoque = 'S' and u.natureza is null and t.bloqueado = 'N'
order by 2,4

select distinct u.descricao from faprdcad t, fatipcad u
where t.tipo_prd = u.tipo_prd
and u.faturavel = 'N' and t.bloqueado = 'N'

--and u.tem_estoque = 'S' and u.natureza is null and t.bloqueado = 'N'
order by 2,4

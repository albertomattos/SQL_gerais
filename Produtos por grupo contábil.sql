select codigo, a.descricao, a.tipo_prd, b.descricao, a.cod_gcn, c.descricao from faprdcad a, fatipcad b, esgcncad c
where a.tipo_prd = b.tipo_prd and a.cod_gcn = c.cod_gcn(+)
and bloqueado = 'N'
order by 6,4,2

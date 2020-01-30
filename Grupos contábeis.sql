select t.codigo, t.tipo_prd, u.descricao, t.descricao, t.cod_gcn, v.descricao from faprdcad t, fatipcad u, esgcncad v
where t.tipo_prd = u.tipo_prd and t.cod_gcn = v.cod_gcn(+) and u.natureza is null
/*and t.cod_gcn is null*/ and u.pre_class = 'MAT' order by 6

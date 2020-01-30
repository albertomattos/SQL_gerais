select t.cod_pro, x.nome_pro, u.tipo_prd, v.descricao, count(t.cod_pro) from immovprd t, faprdcad u, fatipcad v, faprocad x
where t.cod_prd = u.codigo and u.tipo_prd = v.tipo_prd and t.cod_pro = x.cod_pro
and t.dt_lib_res between '01/01/2014' and '30/01/2014'
and t.cod_prd in (select codigo from faprdcad where tipo_prd not in ('LAB', 'EXA', 'MEN'))
group by t.cod_pro, x.nome_pro, u.tipo_prd, v.descricao
order by 3, 4 desc

select t.usu_entrega, u.tipo_prd, v.descricao, count(t.usu_dig_laudo) from immovprd t, faprdcad u, fatipcad v
where t.cod_prd = u.codigo and u.tipo_prd = v.tipo_prd
and t.dt_entrega between '01/01/2014' and '30/01/2014'
and t.cod_prd in (select codigo from faprdcad where tipo_prd not in ('LAB', 'EXA', 'MEN'))
and t.dt_entrega is not null and t.hr_entrega is not null
group by t.usu_entrega, u.tipo_prd, v.descricao
order by 4 desc

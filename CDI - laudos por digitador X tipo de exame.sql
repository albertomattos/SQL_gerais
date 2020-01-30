select t.usu_dig_laudo, u.tipo_prd, v.descricao, count(t.usu_dig_laudo) from immovprd t, faprdcad u, fatipcad v
where t.cod_prd = u.codigo and u.tipo_prd = v.tipo_prd
and t.dt_dig_laudo between '01/01/2014' and '30/01/2014'
and t.cod_prd in (select codigo from faprdcad where tipo_prd not in ('LAB', 'EXA', 'MEN'))
group by t.usu_dig_laudo, u.tipo_prd, v.descricao
order by 3, 4 desc

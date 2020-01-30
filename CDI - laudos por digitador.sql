select t.usu_dig_laudo, count(t.usu_dig_laudo) from immovprd t
where t.dt_dig_laudo between '01/01/2014' and '30/01/2014'
and t.cod_prd in (select codigo from faprdcad where tipo_prd not in ('LAB', 'EXA', 'MEN'))
group by t.usu_dig_laudo
--select * from immovprd

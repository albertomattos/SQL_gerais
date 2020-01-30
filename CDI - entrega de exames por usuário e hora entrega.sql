select t.dt_entrega, to_char(t.hr_entrega, 'HH24:MI') hora, t.usu_entrega, u.tipo_prd, v.descricao, count(t.usu_dig_laudo)
from immovprd t, faprdcad u, fatipcad v
where t.cod_prd = u.codigo and u.tipo_prd = v.tipo_prd
and t.dt_entrega between '01/01/2014' and '30/01/2014'
and to_char(t.hr_entrega, 'HH24:MI') between '00:00' and '23:59'
and t.cod_prd in (select codigo from faprdcad where tipo_prd not in ('LAB', 'EXA', 'MEN'))
group by t.dt_entrega, t.hr_entrega, t.usu_entrega, u.tipo_prd, v.descricao
order by 3, 4 desc

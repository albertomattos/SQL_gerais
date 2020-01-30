select u.tipo_prd, count(u.tipo_prd) from immovprd t, faprdcad u
where t.cod_prd = u.codigo
and t.dt_dig_laudo between '01/07/2013' and '30/09/2013'
and u.tipo_prd not in ('LAB', 'EXA', 'MEN')
group by u.tipo_prd

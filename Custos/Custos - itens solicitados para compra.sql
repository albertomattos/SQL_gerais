select distinct t.set_est, count(t.set_est)
from esmovcad t, esmovite u, faprdcad v, fatipcad z, fasetcad a
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.cod_prd = v.codigo
and a.cod_set = t.set_est
and v.tipo_prd = z.tipo_prd
and t.data_mov between '01/08/2012' and '31/08/2012'
and u.tipo_documento = 'PED'
and z.natureza is null
group by t.set_est
--order by 1

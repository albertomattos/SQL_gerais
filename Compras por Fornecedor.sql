select w.fantasia, sum(u.valor_tot)
from esmovcad t, esmovite u, faprdcad v, esforcad w
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.cod_prd = v.codigo and w.cod_for = t.cod_for
and t.data_emiss between '01/08/2014' and '05/08/2014'
and u.tipo_documento = 'COM'
group by w.fantasia
order by 1

select count(*)
from esmovcad t, esmovite u, faprdcad v, esforcad x, fatipcad z
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.cod_prd = v.codigo
and t.cod_for = x.cod_for
and v.tipo_prd = z.tipo_prd
and t.data_mov between '01/01/2012' and '31/01/2012'
and u.tipo_documento = 'PED'

select :P_MES, :P_ITEM, e.codigo, count(*)
from wpd.esmovcad@prod t, wpd.esmovite@prod u, wpd.faprdcad@prod v, wpd.esforcad@prod x, wpd.fatipcad@prod z, usr_nci.vec_ccus e
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.cod_prd = v.codigo
and t.cod_for = x.cod_for
and v.tipo_prd = z.tipo_prd
and t.set_est = e.cod_cliente
and t.data_mov between :P_DATA_INICIAL and :P_DATA_FINAL
and u.tipo_documento = 'PED'

select e.codigo, count(*)
from wpd.esmovcad@prod t, wpd.esmovite@prod u, wpd.faprdcad@prod v, wpd.esforcad@prod x, wpd.fatipcad@prod z, usr_nci.vec_ccus e
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.cod_prd = v.codigo
and t.cod_for = x.cod_for
and v.tipo_prd = z.tipo_prd
and t.set_est = e.cod_cliente
and t.data_mov between '01/11/2012' and '30/11/2012'
and u.tipo_documento = 'PED'
group by e.codigo

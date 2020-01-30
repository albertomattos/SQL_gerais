select t.cod_pac, t.tipo_documento, u.cod_prd, v.descricao, v.tipo_prd, z.descricao, t.documento, t.data_mov, t.cod_for, x.fantasia,
t.desc_ger, t.desc_ger_val, u.quant, u.valor, u.valor_tot
from esmovcad t, esmovite u, faprdcad v, esforcad x, fatipcad z
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.cod_prd = v.codigo
and t.cod_for = x.cod_for
and v.tipo_prd = z.tipo_prd
and t.documento = '0084411' and t.tipo_documento = 'PED'
--and t.data_mov between '22/10/2012' and '23/10/2012'
--and v.tipo_prd = 'OPM'
--and u.tipo_documento = 'COM'
order by 3

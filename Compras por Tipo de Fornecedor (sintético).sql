select x.descricao, w.fantasia, round(sum(u.valor_tot),2) from esmovcad t, esmovite u, faprdcad v, esforcad w, estfocad x
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.cod_prd = v.codigo and w.cod_for = t.cod_for and w.tipo_for = x.cod_tfo
and t.data_emiss between '01/10/2013' and '31/10/2013'
and u.tipo_documento = 'COM'
--and v.tipo_prd in ('DES','MED','MHL','MMA','OBR','OPM','MEX','GAS','FIO')
--and v.tipo_prd in ('FNU','ICC','MAT','IMO','EQU','LAB')
--and t.documento = '0009415'
and w.fantasia like 'WHITE%'
group by x.descricao, w.fantasia
order by 1

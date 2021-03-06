select t.data_mov, sum(u.valor_tot) from esmovcad t, esmovite u, faprdcad v
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.cod_prd = v.codigo
--and t.data_mov = '03/04/2012'
and t.data_mov between '01/08/2012' and '31/08/2012'
and u.tipo_documento = 'PED'
and v.tipo_prd = 'GAS'
--and v.tipo_prd in ('DES','MED','MHL','MMA','OBR','OPM','MEX','GAS','FIO')
--and v.tipo_prd in ('FNU','ICC','MAT','IMO','EQU','LAB')
group by t.data_mov
order by t.data_mov

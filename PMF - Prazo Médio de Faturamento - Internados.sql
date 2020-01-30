select avg(b.data_emiss - a.data_alta) from fapaccad a, fafatcad b
where a.cod_pac = b.cod_pac
and b.destino = 'C'
and a.tipo_pac = 'I'
and (b.data_emiss - a.data_alta)>0
and b.data_emiss between '01/01/2016' and '29/02/2016'

select b.data_emiss, data_alta from fapaccad a, fafatcad b
where a.cod_pac = b.cod_pac
and b.destino = 'C'
and a.tipo_pac <> 'I'
and (b.data_emiss - a.data_alta)>0
and b.data_emiss between '01/01/2016' and '29/02/2016'

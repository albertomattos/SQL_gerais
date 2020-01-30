select avg(d.data_baixa - d.data_entre) from fapaccad a, fafatcad b, faremcad d
where a.cod_pac = b.cod_pac
and b.remessa = d.remessa
and b.destino = 'C'
and a.tipo_pac = 'I'
and (d.data_baixa - d.data_entre)>0
and d.data_baixa between '01/01/2014' and '31/12/2014'


select d.data_entre, d.data_baixa, (d.data_baixa - d.data_entre) from fapaccad a, fafatcad b, faremcad d
where a.cod_pac = b.cod_pac
and b.remessa = d.remessa
and b.destino = 'C'
and a.tipo_pac = 'I'
and (d.data_baixa - d.data_entre)>0
and d.data_baixa between '01/01/2014' and '31/12/2014'

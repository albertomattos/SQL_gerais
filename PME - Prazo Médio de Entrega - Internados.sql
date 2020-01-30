select avg(d.data_entre - b.data_emiss) from fapaccad a, fafatcad b, faremcad d
where a.cod_pac = b.cod_pac
and b.remessa = d.remessa
and b.destino = 'C'
and a.tipo_pac = 'I'
and (d.data_entre - b.data_emiss)>0
and d.data_entre between '01/01/2015' and '31/12/2015'

select b.fatura, d.data_entre, b.data_emiss from fapaccad a, fafatcad b, faremcad d
where a.cod_pac = b.cod_pac
and b.remessa = d.remessa
and b.destino = 'C'
and a.tipo_pac = 'I'
and (d.data_entre - b.data_emiss)>0
and d.data_entre between '01/01/2015' and '31/12/2015'

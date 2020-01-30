select b.tipo_prd, count(*) qtde from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac
and d.data_ent = &data_ent
--and c.data_mov between '01/05/2012' and '31/05/2012'
and b.tipo_prd in ('RAD', 'USG', 'TOM')
--and b.tipo_prd = 'RAD'
and b.cod_gru not in ('DENS','MAMO')
and d.tipo_pac = 'U'
group by b.tipo_prd
order by b.tipo_prd

--Exames CDI:
select b.tipo_prd, count(*) qtde from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac
and b.codigo = a.codigo
and c.data_mov = &data_mov
--and c.data_mov between '01/04/2012' and '30/04/2012'
and b.tipo_prd in ('RAD','REM','TOM','END','USG')
--and b.tipo_prd in ('END')
and d.tipo_pac <> 'U'
and b.cod_gru not in ('DENS','MAMO')
group by b.tipo_prd
order by b.tipo_prd

select a.cod_pac, b.* from immovcad a, immovprd b, faprdcad c, famovcad d, famovprd e
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and a.cod_pac = d.cod_pac
and b.cod_prd = c.codigo
and d.comanda = e.comanda and d.tipo_comanda = e.tipo_comanda
and a.data_mov between '26/02/2012' and '25/03/2012'
and e.codigo in (select codigo from faprdcad where tipo_prd = 'REM')
and c.tipo_prd = 'REM'
and b.dt_dig_laudo is not null
and b.comanda_fathos is null

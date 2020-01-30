select b.cod_pac, a.dt_dig_laudo, a.cod_pro, a.comanda_fathos from immovprd a, immovcad b where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and a.dt_dig_laudo is not null and a.comanda_fathos is not null
and a.cod_prd in (select codigo from faprdcad where tipo_prd = 'REM')
and b.data_mov between '26/02/2012' and '25/03/2012'

select * from immovprd a, immovcad b where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and a.dt_dig_laudo is not null and a.comanda_fathos is null
and b.cod_pac in (
select c.cod_pac from famovcad c, famovprd d where c.comanda = d.comanda and c.tipo_comanda = d.tipo_comanda
and d.codigo in (select codigo from faprdcad where tipo_prd = 'REM')
)
and a.cod_prd in (select codigo from faprdcad where tipo_prd = 'REM')
and b.data_mov between '26/02/2012' and '25/03/2012'

select c.cod_pac, c.comanda from famovcad c, famovprd d where c.comanda = d.comanda and c.tipo_comanda = d.tipo_comanda
and d.codigo in (select codigo from faprdcad where tipo_prd = 'REM') and c.cod_pac in
(select b.cod_pac from immovprd a, immovcad b where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and a.dt_dig_laudo is not null and a.comanda_fathos is null
and a.cod_prd in (select codigo from faprdcad where tipo_prd = 'REM')
and b.data_mov between '26/02/2012' and '25/03/2012')

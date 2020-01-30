select t.*, t.rowid from lbmovprd t , lbmovcad u where t.tipo_comanda = u.tipo_comanda and t.comanda = u.comanda
and u.cod_pac = '3571773'
update lbmovprd set via_envio = '02' where comanda = '1403005'

select u.cod_pac, t.*, t.rowid from lbmovprd t , lbmovcad u where t.tipo_comanda = u.tipo_comanda and t.comanda = u.comanda
and u.cod_pac = '3774338' and codigo = '050001'
select t.*, t.rowid from lbmlapad t where comanda = '1374992'

update lbmovprd set via_envio = '02' where comanda in (
select comanda from lbmovprd where codigo = '050001' and dt_lib_res = '25/06/2012')

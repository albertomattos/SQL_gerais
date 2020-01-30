select count(t.codigo)
from famovprd t, famovcad u, fapaccad y
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and u.cod_pac = y.cod_pac
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
and u.data_mov between '01/06/2015' and '30/06/2015'
and y.tipo_pac = 'A'

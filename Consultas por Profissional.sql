select *--COUNT(u.cod_pac)
from famovprd t, famovcad u, faprocad v, famovdestino x
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and t.cod_pro = v.cod_pro
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
and t.cod_pro = '000124'
and u.data_mov between '01/06/2018' and '30/06/2018'
and t.tipo_comanda = 'CMED'

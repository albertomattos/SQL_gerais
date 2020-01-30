select a.cod_con, b.fantasia, count(*)
from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad a, faconcad b
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and t.cod_pro = v.cod_pro
and u.cod_pac = a.cod_pac
and a.cod_con = b.cod_con
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
and u.data_mov between '01/06/2013' and '30/06/2013'
group by a.cod_con, b.fantasia
order by b.fantasia

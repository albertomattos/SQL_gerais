select a.cod_pac, c.valor_tot
from famovcad a, famovprd b, famovdestino c, faprdcad d, fapaccad e
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda and a.cod_pac = e.cod_pac
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2016' and '29/07/2016'
and d.tipo_prd = 'CON' and e.cod_con in ('001','002')
order by 1

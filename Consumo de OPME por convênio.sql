select f.fantasia, e.cod_pac, sum(c.valor_tot)
from famovcad a, famovprd b, famovdestino c, faprdcad d, fapaccad e, faconcad f
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda and a.cod_pac = e.cod_pac and e.cod_con = f.cod_con
and b.sequencial = c.sequencial and b.codigo = d.codigo
and a.data_mov between '01/01/2017' and '25/12/2017'
--and e.cod_pac = 'N739476'
--and e.cod_con = '034'
and d.tipo_prd = 'OPM'
group by f.fantasia, e.cod_pac
order by f.fantasia

select f.fantasia, d.codigo, d.descricao
from famovcad a, famovprd b, famovdestino c, faprdcad d, fapaccad e, faconcad f
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda and a.cod_pac = e.cod_pac
and b.sequencial = c.sequencial and b.codigo = d.codigo and e.cod_con = f.cod_con
and a.data_mov between '01/01/2017' and '11/08/2017'
and d.tipo_prd in ('GMD', 'DIA', 'TAX', 'VID')
group by f.fantasia, d.codigo, d.descricao
order by 1,3

select d.codigo, d.descricao, a.req_dev, sum(b.quant)
from famovcad a, famovprd b, famovdestino c, faprdcad d, fapaccad e
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda and a.cod_pac = e.cod_pac
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/07/2016' and '28/06/2017'
and e.cod_con = '034' and d.tipo_prd = 'MED'
group by a.req_dev, d.descricao, d.codigo
order by d.descricao

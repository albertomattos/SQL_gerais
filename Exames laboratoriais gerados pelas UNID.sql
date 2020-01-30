-----Consumo em R$
select distinct d.tipo_prd, a.set_ori, decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d, fapaccad e
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda and a.cod_pac = e.cod_pac
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/02/2016' and '29/02/2016'
and a.set_ori in ('0376')
and e.tipo_pac = 'I'
group by d.tipo_prd, a.set_ori, a.req_dev
order by d.tipo_prd

-----Consumo em Quant
select distinct d.tipo_prd, a.set_ori, decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/02/2016' and '29/02/2016'
and a.set_ori in ('0376')

group by d.tipo_prd, a.set_ori, a.req_dev
order by d.tipo_prd

select distinct (
select round(sum(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot))),2) total
from famovcad a, famovprd b, famovdestino c, faprdcad d, fapaccad e
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and a.cod_pac = e.cod_pac
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2014' and '31/01/2014'
and e.cod_con in ('014','015')
group by a.req_dev)/
(
select round(sum(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot))),2) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2014' and '31/01/2014'
group by a.req_dev)*100
from famovcad a, famovprd b, famovdestino c, faprdcad d, fapaccad e
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and a.cod_pac = e.cod_pac
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2014' and '31/01/2014'

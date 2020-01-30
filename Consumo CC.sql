--Centro Cirúrgico:

--select round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2) total
select a.req_dev,c.valor_tot
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo
and a.set_ori = '0135'
and a.cod_pac = 'J226796'
--group by a.req_dev

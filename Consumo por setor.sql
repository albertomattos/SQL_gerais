-----Tirar esse SQL para a auditoria por setor analítica
select distinct d.tipo_prd, a.set_ori, a.comanda, decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/03/2014' and '31/03/2014'
and a.set_ori in ('0289')
group by d.tipo_prd, a.set_ori, a.comanda, a.req_dev
order by d.tipo_prd
-----Tirar esse SQL para a auditoria por setor sintético
select distinct d.tipo_prd, a.set_ori, decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/03/2014' and '31/03/2014'
and a.set_ori in ('0289')
group by d.tipo_prd, a.set_ori, a.req_dev
order by d.tipo_prd

---Utilizar este SQL para comparar com o wBI
select sum(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot))) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2013' and '31/01/2013'
and b.tipo_pgto <> 'N' --("Não faturável")
group by d.tipo_prd, a.set_ori, a.req_dev
order by d.tipo_prd

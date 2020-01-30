select distinct a.data_mov, d.tipo_prd, a.set_ori, decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/07/2014' and '31/07/2014'
and d.tipo_prd <> 'KIT'-- and c.destino <> 'H'
--and a.set_ori in ('0135')
group by a.data_mov, d.tipo_prd, a.set_ori, a.req_dev
order by d.tipo_prd

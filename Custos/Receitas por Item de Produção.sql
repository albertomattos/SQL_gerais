select d.tipo_prd, d.descricao, '201309', a.set_ori, decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d, fatipcad e
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and d.tipo_prd = e.tipo_prd
and a.data_mov between '01/09/2013' and '30/09/2013'
--and e.pre_class not in ('HON','MAT','KIT','DTX')
--and d.tipo_prd not in ('EXA','END')
and d.tipo_prd not in ('KIT', 'CON', 'PRO', 'DES', 'OPM','MAT','DIA', 'END', 'EXA', 'FIO')
and c.destino <> 'H'
--and d.tipo_prd = 'LAB'
--and a.set_ori = '0025'
group by d.tipo_prd, d.descricao, a.set_ori, a.req_dev
order by d.tipo_prd, d.descricao

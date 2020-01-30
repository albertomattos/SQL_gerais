select a.cod_pac, d.tipo_prd, a.set_ori, d.descricao, a.req_dev, c.valor_tot
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo
and a.data_mov >= '01/01/2016'
and a.data_mov <= '31/05/2016'
and d.tipo_prd in ('MEN')
and a.set_ori not in ('0343')
group by a.cod_pac, d.tipo_prd, a.set_ori, d.descricao, a.req_dev, c.valor_tot

select sum(round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo
and a.data_mov >= $COMPETENCE_FROM
and a.data_mov <= $COMPETENCE_UNTIL
and d.tipo_prd not in ('RAD','REM','TOM','USG','MEN')
and a.set_ori in ('0039','0067','0120','0149','0190','0258','0290','0291','0294','0295','0296','0305','0322','0343','0382','0397')
group by a.req_dev

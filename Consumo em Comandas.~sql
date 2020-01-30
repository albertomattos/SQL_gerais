and a.data_mov >= $COMPETENCE_FROM
and a.data_mov <= $COMPETENCE_UNTIL

--Laboratório:
select round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2015' and '31/01/2015'
and a.set_ori = '0376'
group by a.req_dev

--Unidades de Internação:
select round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2015' and '31/01/2015'
and a.set_ori in ('0006','0104','0130','0132','0133','0134','0191','0453')
group by a.req_dev

--Centro Médico:
select round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2015' and '31/01/2015'
and a.set_ori = '0289'
group by a.req_dev

--Pronto Socorro:
select d.descricao, c.valor_tot
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo
and a.data_mov >= '01/07/2016'
and a.data_mov <= '14/07/2016'
and a.set_ori in ('0026','0118')
group by d.descricao, c.valor_tot

--Centro Cirúrgico:
select round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2015' and '31/01/2015'
and a.set_ori = '0135'
group by a.req_dev

--Day Hospital:
select round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2015' and '31/01/2015'
and a.set_ori in ('0022','0312')
group by a.req_dev

--Oftalmo:
select round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2015' and '31/01/2015'
and a.set_ori in ('0054','0061')
group by a.req_dev

--UTI Neonatal:
select round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/01/2015' and '31/01/2015'
and a.set_ori = '0128'
group by a.req_dev

--CDI:
select sum(round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/04/2015' and '30/04/2015'
and a.set_ori in ('0039','0067','0120','0149','0190','0258','0290','0291','0294','0295','0296','0305','0322','0343','0382',
'0397')
group by a.req_dev

--Geral:
select sum(round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '19/10/2016' and '19/10/2016'
--and a.set_ori = '0136'
and c.destino <> 'H' and b.tipo_pgto <> 'N'
group by a.req_dev

--Bradesco:
select sum(round(decode(a.req_dev,'D',sum(c.valor_tot)*(-1),sum(c.valor_tot)),2)) total
from famovcad a, famovprd b, famovdestino c, faprdcad d, fapaccad e
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and a.cod_pac = e.cod_pac
and b.sequencial = c.sequencial and b.codigo = d.codigo and a.data_mov between '01/04/2015' and '30/04/2015'
and e.cod_con in ('014','015')
group by a.req_dev

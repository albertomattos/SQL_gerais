--Ergometria, Ecocardio e ECG:
select b.descricao, count(*) qtde from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac
and b.codigo = a.codigo
and c.data_mov = '01/11/2012'
--and c.data_mov between '01/05/2012' and '31/05/2012'
and b.codigo in ('009360','009270','009200','009250','052021','052022')
group by b.descricao
order by b.descricao desc

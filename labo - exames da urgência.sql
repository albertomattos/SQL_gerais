select c.data_mov, count(*) qtde from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and d.data_ent = '18/04/2012' and b.tipo_prd in ('LAB') and d.tipo_pac = 'U'
group by c.data_mov order by c.data_mov desc

select c.data_mov, count(*) qtde from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and b.codigo = a.codigo
and c.data_mov = '18/04/2012'
and b.codigo in ('049912','049913','050004')
and d.tipo_pac = 'U' group by c.data_mov, b.descricao
order by c.data_mov desc

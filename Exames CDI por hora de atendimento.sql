select a.codigo, c.descricao, c.tipo_prd, b.data_mov, b.hora_mov, b.cod_pac from famovprd a, famovcad b, faprdcad c
where a.comanda = b.comanda
and a.tipo_comanda = b.tipo_comanda
and a.codigo = c.codigo
and c.tipo_prd in (select tipo_prd from fatipcad where pre_class = 'EXA')
and c.tipo_prd not in ('LAB', 'EXA', 'MEN')
and b.data_mov between '01/07/2013' and '30/09/2013'
and b.cod_pac in (select cod_pac from fapaccad where tipo_pac = 'E')
order by b.hora_mov, c.tipo_prd, c.descricao

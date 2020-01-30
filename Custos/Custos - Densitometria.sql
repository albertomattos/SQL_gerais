select a.codigo, a.quant, b.descricao, d.cod_pac
from wpd.famovprd@prod a, wpd.faprdcad@prod b, wpd.famovcad@prod c, wpd.fapaccad@prod d
where a.codigo = b.codigo
and a.comanda = c.comanda
and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac
and c.data_mov between '01/06/2013' and '30/06/2013'
and b.tipo_prd = 'RAD'
and b.cod_gru in ('DENS')
--group by e.codigo

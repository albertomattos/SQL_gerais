select count(*)
from wpd.famovprd@prod a, wpd.faprdcad@prod b, wpd.famovcad@prod c, wpd.fapaccad@prod d
where a.codigo = b.codigo
and a.comanda = c.comanda
and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac
and c.data_mov between '01/08/2013' and '31/08/2013'
and b.descricao like 'ENDOSCOPIA%'
--group by e.codigo

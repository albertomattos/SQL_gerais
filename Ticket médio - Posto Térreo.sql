select f.valor_guia total
from famovcad a, famovprd b, famovdestino c, faprdcad d, fafatcad e, faremcad f
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and b.codigo = d.codigo
and c.cod_fatura = e.fatura and e.remessa = f.remessa
and f.data_emiss between '01/07/2015' and '31/07/2015'
and c.destino <> 'H'
and a.set_ori = '0133'
group by f.valor_guia

select fasetcad.descricao, SUM(famovprd.valor_tot) total
from fafatcad, famovcad, famovprd, faprdcad, fasetcad
where famovcad.fat_pac = fafatcad.fatura and famovcad.comanda = famovprd.comanda
and fasetcad.cod_set = famovcad.set_ori
and famovprd.codigo = faprdcad.codigo
and fafatcad.data_emiss between "01/08/2005" and "31/08/2005"
and fafatcad.destino = "P"
group by fasetcad.descricao
order by fasetcad.descricao
--select * from fasetcad


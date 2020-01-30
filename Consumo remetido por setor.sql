select fasetcad.descricao, SUM(famovprd.valor_tot) total
from fafatcad, famovcad, famovprd, faprdcad, fasetcad
--where fafatcad.remessa <> "" and famovcad.fat_con = fafatcad.fatura and famovcad.comanda = famovprd.comanda
--where famovcad.fat_con = fafatcad.fatura and famovcad.comanda = famovprd.comanda
where famovcad.comanda = famovprd.comanda
and fasetcad.cod_set = famovcad.set_ori
--and famovprd.codigo = faprdcad.codigo
--and fafatcad.data_emiss between '01/07/2015' and '31/07/2015'
and famovcad.data_mov between '01/07/2015' and '31/07/2015'
--and fafatcad.destino = 'C'
group by fasetcad.descricao
order by fasetcad.descricao
--select * from fafatprd


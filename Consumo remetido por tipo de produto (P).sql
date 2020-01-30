select fatipcad.descricao, SUM(famovprd.valor_tot) total
from fafatcad, famovcad, famovprd, faprdcad, fatipcad
where famovcad.fat_pac = fafatcad.fatura and famovcad.comanda = famovprd.comanda
and faprdcad.tipo_prd = fatipcad.tipo_prd
and famovprd.codigo = faprdcad.codigo
and fafatcad.data_emiss between "01/08/2005" and "31/08/2005"
and fafatcad.destino = "P" and fafatcad.cod_uni = "DAHER"
group by fatipcad.descricao
order by fatipcad.descricao
--select * from fasetcad


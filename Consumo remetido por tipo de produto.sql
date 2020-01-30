select fatipcad.descricao, SUM(famovprd.valor_tot) total
from fafatcad, famovcad, famovprd, faprdcad, fatipcad
where fafatcad.remessa <> "" and famovcad.fat_con = fafatcad.fatura and famovcad.comanda = famovprd.comanda
and faprdcad.tipo_prd = fatipcad.tipo_prd
and famovprd.codigo = faprdcad.codigo
and fafatcad.data_emiss between "01/01/2005" and "31/01/2005"
and fafatcad.destino = "C" and fafatcad.cod_uni = "DAHER"
group by fatipcad.descricao
order by fatipcad.descricao
--select * from fasetcad


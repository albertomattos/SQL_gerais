select faprdcad.tipo_prd,SUM(famovprd.valor_tot)
from fafatcad, famovcad, famovprd, faprdcad
where fafatcad.remessa <> "" and famovcad.fat_con = fafatcad.fatura and famovcad.comanda = famovprd.comanda
and famovprd.codigo = faprdcad.codigo
and (faprdcad.tipo_prd = "TAX" or faprdcad.tipo_prd = "DIA")
and fafatcad.data_emiss between "01/03/2005" and "31/03/2005"
and fafatcad.destino = "C" and fafatcad.cod_uni = "DAHER"
group by faprdcad.tipo_prd
order by faprdcad.tipo_prd


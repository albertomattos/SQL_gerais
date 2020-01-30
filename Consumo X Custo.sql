select fapaccad.cod_pac, faprtcad.nome_pac,req_dev, fatipcad.descricao,faprdcad.codigo,
faprdcad.descricao, famovprd.quant, famovdestino.valor_tot valor_consumo,
faprdcad.custo_atu, faprdcad.custo_atu*famovprd.quant
from fapaccad, faprtcad, fatipcad, faprdcad, famovcad, famovprd, famovdestino
where fapaccad.cod_prt = faprtcad.cod_prt
and famovcad.cod_pac = fapaccad.cod_pac
and famovcad.comanda = famovprd.comanda
and famovprd.sequencial = famovdestino.sequencial
and famovprd.codigo = faprdcad.codigo
and faprdcad.tipo_prd = fatipcad.tipo_prd
and fapaccad.cod_pac = 'N593367'
order by fatipcad.tipo_prd, faprdcad.codigo

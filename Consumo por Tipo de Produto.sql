select sum(famovdestino.valor_tot)
--decode(famovcad.req_dev,'D',sum(famovdestino.valor_tot)*(-1),sum(famovdestino.valor_tot)) total
from fapaccad, faprtcad, fatipcad, faprdcad, famovcad, famovprd, famovdestino
where famovcad.cod_pac = fapaccad.cod_pac
and famovcad.comanda = famovprd.comanda
and famovprd.sequencial = famovdestino.sequencial
and famovprd.codigo = faprdcad.codigo
and faprdcad.tipo_prd = fatipcad.tipo_prd
and famovcad.data_mov between '01/01/2017' and '15/01/2017'
and faprdcad.tipo_prd = 'OPM'
--and fapaccad.cod_pac = "A096436" --and faprdcad.codigo = "028820"
group by famovdestino.valor_tot

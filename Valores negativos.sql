select famovcad.comanda, famovcad.cod_pac, famovdestino.valor, famovcad.data_mov, famovcad.usuario
from famovcad, famovprd, faprdcad, famovdestino
where famovcad.comanda = famovprd.comanda
and faprdcad.codigo = famovprd.codigo
and famovprd.sequencial = famovdestino.sequencial
--and famovcad.req_dev = "D"
and famovcad.data_mov between "01/06/2006" and "20/06/2006"
--and faprdcad.tipo_prd = "MED"
and famovdestino.valor > "1000.00"
order by famovdestino.valor desc

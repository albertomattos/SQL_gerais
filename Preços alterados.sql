select distinct famovcad.comanda, famovcad.cod_pac, famovcad.tipo_pac, famovprd.codigo, famovdestino.valor, famovcad.data_mov,
fapaccad.cod_con, fapaccad.cod_pla, faprecad.valor
from famovcad, famovprd, famovdestino, fapaccad, faprecad
where famovcad.comanda = famovprd.comanda
and famovprd.sequencial = famovdestino.sequencial
and famovcad.cod_pac = fapaccad.cod_pac
and famovprd.codigo = faprecad.codigo
and famovcad.data_mov between "01/04/2006" and "01/05/2006"
and famovdestino.valor > "5000.00"
and famovdestino.destino = "C"
--and faprecad.validade = (select MAX(faprecad.validade) from faprecad, faprdcad where tabela = "01" AND (faprecad.codigo = faprdcad.codigo))
and famovdestino.valor <> faprecad.valor
order by faprecad.valor

select famovcad.tipo_comanda, famovcad.fat_con, famovcad.comanda, cod_pac, data_mov, tipo_pac, set_ori, famovdestino.valor_tot,
sum (famovdestino.valor_tot)
from famovcad, famovprd, famovdestino
where (famovcad.set_ori = "5000" or famovcad.set_ori = "7003")
and famovcad.fat_con = ""
and famovprd.comanda=famovcad.comanda
and famovprd.sequencial=famovdestino.sequencial
group by famovcad.tipo_comanda, famovcad.fat_con, famovcad.comanda, cod_pac, data_mov, tipo_pac, set_ori, famovdestino.valor_tot

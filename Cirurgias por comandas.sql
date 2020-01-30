select a.* from famovprd a, famovcad b where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and a.tipo_ato = '01' and b.data_mov between '01/01/2013' and '31/12/2013'
and a. tipo_comanda = 'CCIR'

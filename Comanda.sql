--update famovcad set set_ori = "0032" where comanda = "0030126"
select tipo_comanda, comanda, cod_pac, data_mov, fat_con, set_ori
from famovcad where tipo_comanda = "LABO"-- and data_mov = "24/02/2005"
and set_ori = "0129" and (fat_con = "" and fat_pac = "")
--select * from famovprd where comanda = "0246547"



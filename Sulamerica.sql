select num_guia, cod_pac, tipo_pac, data_ent, data_alta from fapaccad where cod_con = "032" and data_ent > "01/12/2007"
and length (num_guia) > "8" and tipo_pac = "I"-- and cod_mae is null
order by data_alta desc

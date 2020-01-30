select cod_pac, data_ent, hora_ent from fapaccad where data_alta is NULL and leito = 'URGEN'
and data_ent >= '01/06/2007' order by 2
--update fapaccad set data_alta = data_ent where data_alta is NULL and leito = "EXTER"-- and data_ent = "31/07/2003"


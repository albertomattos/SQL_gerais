select cod_pac, data_ent, data_alta, hora_alta, data_alta_medica from fapaccad
where data_ent >= "01/01/2007" and tipo_pac = "I" and data_alta is not null


select falehcad.leito, falehcad.tipo, fapaccad.cod_pac, data_ent, data_alta, data_alta-data_ent, cod_ala from fapaccad, falehcad
where fapaccad.cod_pac = falehcad.cod_pac and fapaccad.tipo_pac='I'
and fapaccad.data_ent between '01/01/2015' and '31/12/2016'
and data_alta-data_ent = '1'
and falehcad.tipo in ('AL','AP','AV','E2','E4','SU','E5')
and fapaccad.tip_atend = 'L'

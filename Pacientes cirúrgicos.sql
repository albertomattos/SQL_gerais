select fapaccad.cod_pac from fapaccad, faprccad
where fapaccad.cod_pac=faprccad.cod_pac
and faprccad.prev_real='R'
and faprccad.cod_set='0135'
and fapaccad.tipo_pac='I'
and fapaccad.data_ent between '01/01/2017' and '31/01/2017'

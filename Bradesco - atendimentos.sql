select count(*) from fapaccad where data_ent between '01/04/2017' and '30/04/2017'
and tipo_pac <> 'I'
and cod_con in ('014','015')

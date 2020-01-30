select b.cod_set from fapaccad a, fapaccom b where a.cod_pac = b.cod_pac
and tipo_pac = 'U' and data_ent between '01/10/2013' and '31/10/2013'
-- Atendimentos pedi�tricos
and cod_ala = 'PSPE'

update fapaccom set cod_set = '0118' where cod_pac in (select cod_pac from fapaccad where tipo_pac = 'U'
and data_ent between '01/11/2013' and '30/11/2013' and cod_ala <> 'PSPE')

update fapaccom set cod_set = '0026' where cod_pac in (select cod_pac from fapaccad where tipo_pac = 'U'
and data_ent between '01/11/2013' and '30/11/2013' and cod_ala = 'PSPE')
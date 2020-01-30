select count(*) from fapaccad a, fapaccom b
where a.cod_pac = b.cod_pac
and a.tipo_pac = 'I'
and a.data_ent between '01/01/2012' and '31/12/2012'
and b.cod_set not in ('0312','0022')
--Day Hospital
select count(*) from fapaccad a, fapaccom b
where a.cod_pac = b.cod_pac
and a.tipo_pac = 'I'
and a.data_ent between '01/01/2012' and '31/12/2012'
and b.cod_set in ('0312','0022')

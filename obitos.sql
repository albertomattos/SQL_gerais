select fapaccom.cod_pac, num_atestado_obito, fapaccad.data_alta from fapaccom, fapaccad
where fapaccom.cod_pac = fapaccad.cod_pac
and num_atestado_obito is not null and num_atestado_obito <> ""
and fapaccad.data_alta >= "01/01/2007"
order by fapaccad.data_alta
select cod_pac, data_alta, cod_mot_alta from fapaccad
where cod_mot_alta in ('02','41','43','44','45','46','51','52','53','54')
and data_alta >= "01/01/2007"
order by data_alta

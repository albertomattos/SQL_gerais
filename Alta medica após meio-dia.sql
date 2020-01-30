--Alta médica após 12 horas
select a.cod_ala, a.data_ent, a.data_alta, a.hora_alta, a.data_alta_medica, to_char(a.data_alta_medica,'HH24:MI') from fapaccad a
where a.data_alta_medica >= '01/07/2015' and a.data_alta_medica <= '01/08/2015'
and a.tipo_pac = 'I' and a.data_alta_medica is not null
and to_char(a.data_alta_medica,'HH24:MI')<='12:00'
and a.cod_ala <> 'HMDA'

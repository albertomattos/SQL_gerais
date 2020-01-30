select cod_mot_alta, cod_pac from fapaccad where data_alta between "01/01/2007" and "31/01/2007"
and tipo_pac = "I"
order by cod_mot_alta
select * from fapaccom where cod_pac = "E385480"
select * from suaihcad  where tipo_alta = "01" cod_pac = "E385480"

update fapaccad set cod_mot_alta = "39" where cod_mot_alta = "37" and data_alta between "01/01/2000" and "31/12/2003"
and tipo_pac = "I"

select * from fapaccad where cod_mot_alta >= "72"

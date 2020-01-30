select t.cod_pac, t.data_ent, t.data_alta, t.hora_ent, t.hora_alta, t.cod_mot_alta, t.rowid from fapaccad t
--where t.data_alta between &data_alta and &data_alta
where t.data_alta between '01/01/2013' and '31/01/2013'
and t.moti_alta = 'O'
and t.tipo_pac = 'I'
order by t.cod_mot_alta;
--Motivo 07 ap�s 24 horas. Contar esses �bitos/sa�das no per�odo (- hemodi�lise). Motivo 08 at� 24 horas.

select count(*) from fapaccad t
where t.data_alta between '01/01/2013' and '31/01/2013'
and t.tipo_pac = 'I' and cod_ala <> 'HMDA';

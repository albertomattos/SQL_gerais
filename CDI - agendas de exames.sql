select cod_sala, to_char(hora_ini,'HH24:MI')hora_ini, to_char(hora_fin,'HH24:MI')hora_fim, dia_semana,
decode(dia_semana,0,'DOMINGO',1,'SEGUNDA',2,'TERCA',3,'QUARTA',4,'QUINTA',5,'SEXTA',6,'SABADO') dia, faalacad.descricao
from imatecad, faalacad where imatecad.cod_ala = faalacad.cod_ala(+)
and cod_pro = ' ' and cod_sala not in ('CHEC')
order by cod_sala, dia_semana

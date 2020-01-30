--select * from fahurcad where tipo_pac = 'I' order by dia_sem

--update fahurcad set hora_ini="12:00" where hora_ini = "19:00" and dia_sem = "6"
--update fahurcad set hora_fin="06:59" where hora_fin = "05:59" and cod_con = "068"-- and dia_sem = "6"
--select * from fahurcad where dia_sem = "6" and hora_ini = "12:00"--dia_sem = "0"

select b.fantasia convenio, c.nome_plano plano,
decode(a.dia_sem,'0','Domingo','1','Segunda','2','Terça','3','Quarta','4','Quinta',5,'Sexta','6','Sábado') dia_da_semana,
to_char(a.hora_ini,'HH24:MI') hora_inicial, to_char(a.hora_fin,'HH24:MI') hora_final
from fahurcad a, faconcad b, faplacad c where a.cod_con = b.cod_con and a.cod_pla = c.cod_pla and b.cod_con = c.cod_con
and a.tipo_pac = 'I' order by b.fantasia, c.nome_plano, a.dia_sem, hora_inicial

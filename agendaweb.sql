create view agendaweb as select u.nome_pro, x.descricao, t.data, to_char(t.hora_ini,'hh24:mi') hora_ini, to_char(t.hora_fin,'hh24:mi') hora_fim
from imagncad t, faprocad u, faesppro v, faespcad x
where t.cod_pro = u.cod_pro and u.cod_pro = v.cod_pro and v.cod_esp = x.cod_esp
and v.sn_principal = 'S'
and t.data >= sysdate and t.suspenso = 'N'
order by 2,1,3,4

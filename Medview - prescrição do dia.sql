select distinct t.cod_pac, v.nome_pac, t.leito, t.data_hora_ini
from prescricao_pac t, fapaccad u, faprtcad v, faprdcad w
where t.cod_pac = u.cod_pac and u.cod_prt = v.cod_prt and t.codigo = w.codigo
and t.data_hora_ini between to_date('2015/09/29','YYYY/MM/DD HH24:MI')
and to_date('2015/09/30','YYYY/MM/DD HH24:MI')
and t.leito <> 'URGEN'
order by t.leito

select t.cod_pac, v.nome_pac, t.leito, t.codigo, w.descricao, t.data_hora_ini
from prescricao_pac t, fapaccad u, faprtcad v, faprdcad w
where t.cod_pac = u.cod_pac and u.cod_prt = v.cod_prt and t.codigo = w.codigo
and t.data_hora_ini between to_date('2013/03/26','YYYY/MM/DD HH24:MI')
and to_date('2013/03/27','YYYY/MM/DD HH24:MI')
order by v.nome_pac, w.descricao

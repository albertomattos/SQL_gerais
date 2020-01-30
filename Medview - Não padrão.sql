select count(t.codigo)
from prescricao_pac t, fapaccad u, faprtcad v, faprdcad w
where t.cod_pac = u.cod_pac and u.cod_prt = v.cod_prt and t.codigo = w.codigo
and t.data_hora_ini between to_date('2017/09/01','YYYY/MM/DD HH24:MI')
and to_date('2017/09/30','YYYY/MM/DD HH24:MI')
and t.codigo = '205006'
order by v.nome_pac, w.descricao

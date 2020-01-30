select * from fapaccad where leito is not null and leito not in ('URGEN','EXTER','AMBUL')
and leito not like 'P%' and cod_pac not in (

select t.cod_pac
from prescricao_pac t, fapaccad u, faprtcad v, faprdcad w
where t.cod_pac = u.cod_pac and u.cod_prt = v.cod_prt and t.codigo = w.codigo
and t.data_hora_ini between to_date('2015/09/29','YYYY/MM/DD HH24:MI')
and to_date('2015/09/30','YYYY/MM/DD HH24:MI')
)

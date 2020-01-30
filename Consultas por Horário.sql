select to_char(u.hora_mov,'HH24:MI') hora, u.cod_pac, t.cod_pro, v.nome_pro, x.valor_tot, b.fantasia convenio
from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad a, faconcad b
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and t.cod_pro = v.cod_pro
and u.cod_pac = a.cod_pac
and a.cod_con = b.cod_con
and a.tipo_pac = 'U'
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
and u.data_mov between '01/08/2013' and '31/08/2013'
and (to_char(u.hora_mov,'HH24:MI') between '19:00' and '23:59'
or to_char(u.hora_mov,'HH24:MI') between '00:00' and '06:59')
order by 4

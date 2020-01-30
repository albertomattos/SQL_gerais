select t.codigo, u.cod_pac, t.cod_pro, x.valor_tot, v.nome_pro, x.cod_fatura
from famovprd t, famovcad u, faprocad v, famovdestino x
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and t.cod_pro = v.cod_pro
--and t.cod_pac = x.cod_pac
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
and u.data_mov between '01/01/2012' and '31/01/2012'

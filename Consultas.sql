select distinct u.set_ori, t.codigo, u.cod_pac, t.cod_pro, v.nome_pro, x.cod_fatura, x.valor_tot, z.valor_pago, b.fantasia
from famovprd t, famovcad u, faprocad v, famovdestino x, fafatprd z, fapaccad a, faconcad b
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and t.cod_pro = v.cod_pro
and x.cod_fatura = z.fatura(+)
and u.cod_pac = a.cod_pac
and a.cod_con = b.cod_con
and a.tipo_pac = 'A'
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
and u.data_mov between '01/06/2015' and '30/06/2015'
--and x.cod_fatura is null
order by u.set_ori, v.nome_pro

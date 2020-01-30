select a.nome_pac, x.cod_pac, t.cod_prd, u.descricao, t.quant, b.data_ent, b.hora_ent,-- g.data_hora,
t.dt_dig_laudo, t.hr_dig_laudo,
t.dt_imp_laudo, t.hr_imp_laudo, t.dt_lib_res, t.hr_lib_res,
t.dt_entrega, t.hr_entrega
--, t.dt_rec_laudo, t.hr_rec_laudo
from immovprd t, faprdcad u, fatipcad v, immovcad x, faprtcad a, fapaccad b, pedidos_proced g, itens_ped_proced i
where t.comanda = x.comanda and t.tipo_comanda = x.tipo_comanda
and t.cod_prd = u.codigo and u.tipo_prd = v.tipo_prd
and x.cod_pac = b.cod_pac
and b.cod_prt = a.cod_prt and g.num_pedido = i.num_pedido and x.cod_pac = g.cod_pac
and t.dt_prev_entrega = '15/03/2018' and v.tipo_prd = 'CON'
and x.cod_pac = 'Q259014'

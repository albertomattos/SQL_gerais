select g.data_hora, f.Num_Pedido, f.cod_prd, h.descricao,f.confirmado,f.dh_canc_pedido, g.data_hora+0.25 cancela,f.rowid 
from  ITENS_PED_PROCED f, faprdcad h, pedidos_proced g
where f.cod_prd = h.codigo and f.num_pedido = g.num_pedido
and f.num_pedido in (select distinct g.num_pedido
from pedidos_proced g, itens_ped_proced i, faprdcad j where g.num_pedido = i.num_pedido and i.cod_prd = j.codigo
and i.confirmado = 'N' and i.dh_canc_pedido is null and i.comanda IS NULL and j.tipo_prd = 'LAB')
and h.tipo_prd = 'LAB' and f.confirmado = 'N' and f.dh_canc_pedido is null
and g.cod_pac in (select cod_pac from fapaccad where tipo_pac <> 'I')
order by 1

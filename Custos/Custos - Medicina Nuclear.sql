select c.set_ori, b.* from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between '01/08/2012' and '31/08/2012'
and b.tipo_prd = 'MEN'

select :P_MES, :P_ITEM, e.codigo, count(*)
from wpd.famovprd@prod a, wpd.faprdcad@prod b, wpd.famovcad@prod c, wpd.fapaccad@prod d, usr_nci.vec_ccus e
where a.codigo = b.codigo
and a.comanda = c.comanda
and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac
and c.set_ori = e.cod_cliente
and c.data_mov between :P_DATA_INICIAL and :P_DATA_FINAL
and b.tipo_prd = 'MEN'
group by e.codigo

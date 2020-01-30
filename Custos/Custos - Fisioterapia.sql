/*select distinct sum(sum(a.quant)) from famovprd a, faprdcad b, famovcad c where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.data_mov between '01/07/2013' and '31/07/2013'
and b.tipo_prd = 'FIS'
group by a.quant
*/
--select :P_MES, :P_ITEM, e.codigo, count(*)
select sum(a.quant)
from wpd.famovprd@prod a, wpd.faprdcad@prod b, wpd.famovcad@prod c--, wpd.fapaccad@prod d--, usr_nci.vec_ccus e
where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
--and c.cod_pac = d.cod_pac
--and c.set_ori = e.cod_cliente
and c.data_mov between '01/01/2017' and '31/01/2017'
--and c.data_mov between :P_DATA_INICIAL and :P_DATA_FINAL
and b.tipo_prd = 'FIS'
--group by e.codigo


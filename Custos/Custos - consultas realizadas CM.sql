select count(t.codigo)
from famovprd t, famovcad u, famovdestino x, fapaccad y
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and u.cod_pac = y.cod_pac
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
and u.data_mov between '01/09/2012' and '30/09/2012'
and y.tipo_pac = 'A'
---------- SQL para o NCI Custos:
select c.cod_cliente
from wpd.famovprd@prod t, wpd.famovcad@prod u, wpd.famovdestino@prod x, wpd.fapaccad@prod y, usr_nci.vec_ccus c, wpd.faprdcad@prod z
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and u.cod_pac = y.cod_pac
and t.codigo = z.codigo
and u.data_mov between '01/07/2012' and '31/07/2012'
and z.tipo_prd = 'CON'
and y.tipo_pac = 'A'
and c.cod_cliente = u.set_ori
group by c.cod_cliente

select :P_MES, :P_ITEM, c.cod_cliente
from wpd.famovprd@prod t, wpd.famovcad@prod u, wpd.famovdestino@prod x, wpd.fapaccad@prod y, usr_nci.vec_ccus c, wpd.faprdcad@prod z
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and u.cod_pac = y.cod_pac
and t.codigo = z.codigo
and u.data_mov between :P_DATA_INICIAL and :P_DATA_FINAL
and z.tipo_prd = 'CON'
and y.tipo_pac = 'A'
and c.cod_cliente = u.set_ori
group by c.cod_client

-- Ajustar as comandas para o setor correto:
update famovcad set set_ori = 0289 where cod_pac in (
select u.cod_pac
from famovprd t, famovcad u, famovdestino x, fapaccad y
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and u.cod_pac = y.cod_pac
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
and u.data_mov between '01/09/2012' and '30/09/2012'
and y.tipo_pac = 'A'
and u.set_ori = '0312')

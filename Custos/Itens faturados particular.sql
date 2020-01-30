select * from famovcad a, famovprd b, fapaccad c
where a.tipo_comanda = b.tipo_comanda and a.comanda = b.comanda
and a.cod_pac = c.cod_pac
and c.cod_con in ('001','002')
and a.data_mov between '01/02/2013' and '28/02/2013'

select count(*)
from wpd.famovcad@prod a, wpd.famovprd@prod b, wpd.fapaccad@prod c, usr_nci.vec_ccus e
where a.tipo_comanda = b.tipo_comanda and a.comanda = b.comanda
and a.cod_pac = c.cod_pac and a.set_ori = e.cod_cliente
and c.cod_con in ('001','002')
and a.data_mov between '01/02/2013' and '28/02/2013'

select :P_MES, :P_ITEM, e.codigo, count(*)
from wpd.famovcad@prod a, wpd.famovprd@prod b, wpd.fapaccad@prod c, usr_nci.vec_ccus e
where a.tipo_comanda = b.tipo_comanda and a.comanda = b.comanda
and a.cod_pac = c.cod_pac and a.set_ori = e.cod_cliente
and c.cod_con in ('001','002')
and a.data_mov between :P_DATA_INICIAL and :P_DATA_FINAL

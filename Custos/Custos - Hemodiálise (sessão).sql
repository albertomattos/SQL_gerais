select sum(a.quant) from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between '01/11/2013' and '30/11/2013'
and b.cod_gru = 'HMDL'

--SQL para NCI:
select :P_MES, :P_ITEM, d.codigo, count(*) from wpd.famovprd@prod a, wpd.faprdcad@prod b, wpd.famovcad@prod c, usr_nci.vec_ccus d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.set_ori = d.cod_cliente and c.data_mov between :P_DATA_INICIAL and :P_DATA_FINAL
and b.cod_gru = 'HMDL'
group by d.codigo

--Ajuste de comanda (setor):
update famovcad set set_ori = '0136' where cod_pac in (
select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between '01/09/2012' and '30/09/2012'
and b.cod_gru = 'HMDL'
and c.set_ori <> '0136')
and comanda in (
select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between '01/09/2012' and '30/09/2012'
and b.cod_gru = 'HMDL'
and c.set_ori <> '0136')

/*select distinct c.set_ori from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between '01/09/2012' and '30/09/2012'
and b.tipo_prd = 'TOM'
--and b.cod_gru in ('DENS') group by c.data_mov
-----------
select * from (select distinct(b.descricao), count(*) from wpd.famovprd@prod a, wpd.faprdcad@prod b, wpd.famovcad@prod c, wpd.fapaccad@prod d,
usr_nci.vec_ccus e
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac
and c.set_ori = e.cod_cliente and c.data_mov between '01/08/2012' and '31/08/2012'
and b.tipo_prd = 'END'
group by b.descricao
union
select distinct(b.descricao), count(*) from wpd.famovprd@prod a, wpd.faprdcad@prod b, wpd.famovcad@prod c, wpd.fapaccad@prod d,
usr_nci.vec_ccus e
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac
and c.set_ori = e.cod_cliente and c.data_mov between '01/08/2012' and '31/08/2012'
and b.tipo_prd = 'PAC' and b.descricao like '%ENDOS%'
group by b.descricao)
-----------
select :P_MES, :P_ITEM, e.codigo, count(*) from wpd.famovprd@prod a, wpd.faprdcad@prod b, wpd.famovcad@prod c, wpd.fapaccad@prod d,
usr_nci.vec_ccus e
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac
and c.set_ori = e.cod_cliente and c.data_mov between :P_DATA_INICIAL and :P_DATA_FINAL
and b.tipo_prd = 'END'
group by e.codigo
union
select :P_MES, :P_ITEM, e.codigo, count(*) from wpd.famovprd@prod a, wpd.faprdcad@prod b, wpd.famovcad@prod c, wpd.fapaccad@prod d,
usr_nci.vec_ccus e
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac
and c.set_ori = e.cod_cliente and c.data_mov between :P_DATA_INICIAL and :P_DATA_FINAL
and b.tipo_prd = 'PAC' and b.descricao like '%ENDOS%'
group by e.codigo
*/

--Atualiza Raio-X
update famovcad set set_ori = '0149' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between 
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'RAD' and b.cod_gru not in ('DENS','MAMO')
and c.set_ori <> '0149') and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between 
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'RAD' and b.cod_gru not in ('DENS','MAMO') and c.set_ori <> '0149');

--Atualiza Tomografia
update famovcad set set_ori = '0190' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between 
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'TOM' and c.set_ori <> '0190') and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between 
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'TOM' and c.set_ori <> '0190');

--Atualiza Ultrassonografia
update famovcad set set_ori = '0291' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'USG' and c.set_ori <> '0291') and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'USG' and c.set_ori <> '0291');

--Atualiza Ressonância
update famovcad set set_ori = '0290' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'REM' and c.set_ori <> '0290') and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'REM' and c.set_ori <> '0290');

--Atualiza Mamografia
update famovcad set set_ori = '0294' where cod_pac in ( select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'RAD' and b.cod_gru = 'MAMO' and c.set_ori <> '0294')
and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'RAD' and b.cod_gru = 'MAMO' and c.set_ori <> '0294');

--Atualiza Densitometria
update famovcad set set_ori = '0295' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'RAD' and b.cod_gru = 'DENS' and c.set_ori <> '0295')
and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'RAD' and b.cod_gru = 'DENS' and c.set_ori <> '0295');

--Atualiza Endoscopia
--Parte I
update famovcad set set_ori = '0120' where cod_pac in (
select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac
and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'PAC' and b.descricao like '%ENDOS%'
and c.set_ori <> '0120')
and comanda in (
select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac
and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'PAC' and b.descricao like '%ENDOS%'
and c.set_ori <> '0120');
--Parte II
update famovcad set set_ori = '0120' where cod_pac in (
select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'END'
and c.set_ori <> '0120')
and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/09/2012' and '30/09/2012'
and b.tipo_prd = 'END'
and c.set_ori <> '0120');
--Atualiza Raio-X
update famovcad set set_ori = '0149' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between 
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'RAD' and b.cod_gru not in ('DENS','MAMO')
and c.set_ori <> '0149') and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between 
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'RAD' and b.cod_gru not in ('DENS','MAMO') and c.set_ori <> '0149');

--Atualiza Tomografia
update famovcad set set_ori = '0190' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between 
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'TOM' and c.set_ori <> '0190') and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between 
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'TOM' and c.set_ori <> '0190');

/*Atualiza Ultrassonografia (não utilizar)
update famovcad set set_ori = '0291' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/05/2013' and '31/05/2013'
and b.tipo_prd = 'USG' and c.set_ori <> '0291') and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between
'01/05/2013' and '31/05/2013'
and b.tipo_prd = 'USG' and c.set_ori <> '0291');*/

--Atualiza Ressonância
update famovcad set set_ori = '0290' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'REM' and c.set_ori <> '0290') and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'REM' and c.set_ori <> '0290');

--Atualiza Mamografia
update famovcad set set_ori = '0294' where cod_pac in ( select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'RAD' and b.cod_gru = 'MAMO' and c.set_ori <> '0294')
and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'RAD' and b.cod_gru = 'MAMO' and c.set_ori <> '0294');

--Atualiza Densitometria
update famovcad set set_ori = '0295' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'RAD' and b.cod_gru = 'DENS' and c.set_ori <> '0295')
and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'RAD' and b.cod_gru = 'DENS' and c.set_ori <> '0295');

--Atualiza Endoscopia
--Parte I
update famovcad set set_ori = '0120' where cod_pac in (
select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac
and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'PAC' and b.descricao like '%ENDOS%'
and c.set_ori <> '0120')
and comanda in (
select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac
and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'PAC' and b.descricao like '%ENDOS%'
and c.set_ori <> '0120');
--Parte II
update famovcad set set_ori = '0120' where cod_pac in (
select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'END'
and c.set_ori <> '0120')
and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.tipo_prd = 'END'
and c.set_ori <> '0120');
drop table endosc_count;
create table endosc_count (set_ori varchar2(4), num_exames varchar2(4), data_mov date);
/*insert into endosc_count values ('0120',
(select count(*) from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac
and c.data_mov between
'01/07/2013' and '31/07/2013'
and b.tipo_prd = 'END'
group by c.set_ori),
'01/07/2013'
);*/
insert into endosc_count values ('0120',
(select count(*) from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac
and c.data_mov between
'01/07/2013' and '31/07/2013'
and b.tipo_prd in ('PAC','PRO') and b.descricao like 'ENDOS%'
group by c.set_ori),
'01/07/2013'
); select * from endosc_count

--Atualiza Hemodiálise
update famovcad set set_ori = '0136' where cod_pac in ( select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.cod_gru = 'HMDL' and c.set_ori <> '0136') and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.cod_gru = 'HMDL' and c.set_ori <> '0136');

--Atualiza Centro Médico
update famovcad set set_ori = '0289' where cod_pac in (select u.cod_pac from famovprd t, famovcad u, famovdestino x, fapaccad y
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda and t.sequencial = x.sequencial and u.cod_pac = y.cod_pac
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON') and u.data_mov between
'01/06/2013' and '30/06/2013'
and y.tipo_pac = 'A' and u.set_ori not in ('0289','0312','0019','0054'));

--Correçao de setores PS Adulto:
update fapaccom set cod_set = '0118' where cod_pac in (select cod_pac from wpd.fapaccad@prod where tipo_pac = 'U' and data_ent between
'01/05/2013' and '31/05/2013'
and cod_ala <>'PSPE') and cod_set <> '0118';

--Correçao de setores PS Pediátrico:
update fapaccom set cod_set = '0026' where cod_pac in ( select cod_pac from wpd.fapaccad@prod where tipo_pac = 'U' and data_ent between
'01/05/2013' and '31/05/2013'
and cod_ala ='PSPE') and cod_set <> '0026';

--Atualiza Estudo Urodinâmico
update famovcad set set_ori = '0296' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.codigo in ('052216','052217') and c.set_ori <> '0296') and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between
'01/06/2013' and '30/06/2013'
and b.codigo in ('052216','052217') and c.set_ori <> '0296');

commit;

-- Atualiza Cardiologia (ainda não rodar, pois o tipo EXA tem em outras comandas)
/*update famovcad set set_ori = '0382' where cod_pac in (select c.cod_pac from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac and c.data_mov between
'01/10/2012' and '31/10/2012'
and b.tipo_prd = 'EXA' and c.set_ori <> '0382') and comanda in (select c.comanda from famovprd a, faprdcad b, famovcad c, fapaccad d
where a.codigo = b.codigo and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda and c.cod_pac = d.cod_pac and c.data_mov between
'01/10/2012' and '31/10/2012'
and b.tipo_prd = 'EXA' and c.set_ori <> '0382');
*/

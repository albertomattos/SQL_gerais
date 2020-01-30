create table lab_mapa_exames
(num_exa varchar2(7), mes_ano varchar2(6), tkt_med_mes varchar2(

select count(*) from famovprd a, faprdcad b, famovcad c
where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.data_mov between
'01/01/2008' and '31/12/2008'
and c.set_ori = '0376'
and b.tipo_prd in ('LAB', 'MEN', 'EXA')
union
select count(*) from wpd.famovprd@prodantigo a, wpd.faprdcad@prodantigo b, wpd.famovcad@prodantigo c
where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.data_mov between
'01/01/2008' and '31/12/2008'
and c.set_ori in ('0137','0311','0344','0346','0347','0348','0349','0351','0374','0375','0376','0377','0378','0406')
and b.tipo_prd = ('PAT')
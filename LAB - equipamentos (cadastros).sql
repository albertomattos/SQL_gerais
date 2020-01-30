select t.*, t.rowid from equipamento t
select t.*, t.rowid from equipprdcomp t where t.cod_equip = 'ABL80'
select t.*, t.rowid from equipcomp t where t.cod_equip = 'VECI1' order by 2,4
--select distinct t.cod_prd from equipprdcomp t where t.cod_equip = 'VECI1'
select u.*, u.rowid from lbmovequip u where u.cod_prd = '051155'
select comanda, codigo, dt_dig_laudo, laudo from lbmovprd where comanda = '5341459' and codigo = '051155'
select a.*, a.rowid from lbmovprd a where a.comanda = '5341655' and a.codigo = '051156'
select * from lbmlapad where comanda = '5341459' and cod_prd = '051156'

select * from ti_ctr_labhos where comanda = '5341459'

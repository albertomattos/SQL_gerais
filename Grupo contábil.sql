select codigo, cod_gcn, descricao, tipo_prd from faprdcad where tipo_prd = 'MTF' and bloqueado = 'N' order by cod_gcn

select * from fatipcad

select codigo, cod_gcn, tipo_prd from faprdcad where /*cod_gcn is null and*/ tipo_prd in (select faprdcad.tipo_prd from faprdcad, fatipcad, esgcncad
where faprdcad.tipo_prd = fatipcad.tipo_prd and esgcncad.cod_gcn = faprdcad.cod_gcn and fatipcad.pre_class = 'MAT'
/*and faprdcad.cod_gcn is not null*/) and bloqueado = 'N' order by 3

select codigo, cod_gcn, tipo_prd from faprdcad where cod_gcn = '111503001'

update faprdcad set cod_gcn = '111503001' where tipo_prd = 'MED';
update faprdcad set cod_gcn = '111503002' where tipo_prd = 'MEL';
update faprdcad set cod_gcn = '111503003' where tipo_prd = 'EQU';
--update faprdcad set cod_gcn = '111503004' where tipo_prd = 'EQC';
update faprdcad set cod_gcn = '111503005' where tipo_prd = 'FIO';
update faprdcad set cod_gcn = '111503006' where tipo_prd = 'FNU';
update faprdcad set cod_gcn = '111503007' where tipo_prd = 'MAT';
--update faprdcad set cod_gcn = '111503008' where tipo_prd = 'MLA';
--update faprdcad set cod_gcn = '111503009' where tipo_prd = 'MTF';
--update faprdcad set cod_gcn = '111503010' where tipo_prd = 'MTH';
update faprdcad set cod_gcn = '111503011' where tipo_prd = 'OPM';
--update faprdcad set cod_gcn = '111503012' where tipo_prd = 'EPI';
update faprdcad set cod_gcn = '111503013' where tipo_prd = 'MEX';
update faprdcad set cod_gcn = '111503014' where tipo_prd = 'MHL';
update faprdcad set cod_gcn = '111503015' where tipo_prd = 'MMA';
--update faprdcad set cod_gcn = '111503016' where tipo_prd = 'MAR';
--update faprdcad set cod_gcn = '111503017' where tipo_prd = 'PIN';
update faprdcad set cod_gcn = '111503018' where tipo_prd = 'ENX';
--update faprdcad set cod_gcn = '111503019' where tipo_prd = 'SAN';
--update faprdcad set cod_gcn = '111503020' where tipo_prd = 'STI';
update faprdcad set cod_gcn = '111503021' where tipo_prd = 'IMH';
--update faprdcad set cod_gcn = '111503022' where tipo_prd = 'ETI';
update faprdcad set cod_gcn = '111503023' where tipo_prd = 'GAS';
--update faprdcad set cod_gcn = '111503024' where tipo_prd = 'GAS';
update faprdcad set cod_gcn = '111503025' where tipo_prd = 'OBR';
update faprdcad set cod_gcn = '111503026' where tipo_prd = 'ICC';
--update faprdcad set cod_gcn = '111503027' where tipo_prd = 'MOU';
select * from fatipcad
update faprdcad set cod_gcn = '000000000' where tipo_prd = 'IMO' or tipo_prd = 'MMH' or tipo_prd = 'COM'
     or tipo_prd = 'EQU' or tipo_prd = 'MAQ' or tipo_prd = 'INT' or tipo_prd = 'INF' or tipo_prd = 'SOF';

select distinct(faprdcad.cod_gcn), esgcncad.descricao, faprdcad.tipo_prd, fatipcad.descricao from faprdcad, fatipcad, esgcncad
where faprdcad.tipo_prd = fatipcad.tipo_prd and esgcncad.cod_gcn = faprdcad.cod_gcn
and faprdcad.cod_gcn is not null and faprdcad.cod_gcn <> ''

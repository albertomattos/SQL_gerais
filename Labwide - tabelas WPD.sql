--Material de coleta:
select t.*, t.rowid from lbmatcad t
select t.*, t.rowid from lbmatcom t
--Métodos:
select t.*, t.rowid from lbmetcad t
--Componentes:
select t.*, t.rowid from lbcomcad t
--Sensibilidade:
select t.*, t.rowid from lbrescad t
--Composição:
select t.*, t.rowid from lbexacom t where cod_prd = '050069'
--Resultados:
select t.*, t.rowid from lbmlapad t where comanda = '1850152'
--Laudos - padrões:
select t.*, t.rowid from lbpadlau t where t.codigo = '050069'
--LBMOVCAD:
select t.*, t.rowid from lbmovcad t where cod_pac = 'F214539';
select nome_pac, sexo, nascimento from faprtcad where cod_prt in (
       select cod_prt from fapaccad where cod_pac = '5036058');
select cod_prt, data_ent, hora_ent from fapaccad where cod_pac = '5036058';
--LBMOVPRD:
select t.*, t.rowid from lbmovprd t where comanda in (select t.comanda from lbmovcad t where cod_pac = 'F214539')
and t.codigo = '050069'

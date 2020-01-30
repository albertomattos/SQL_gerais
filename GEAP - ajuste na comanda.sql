select u.*, u.rowid from famovprd u where u.comanda in (select t.comanda from famovcad t where t.cod_pac = 'G859607') and u.codigo = '203130'

select t.*, t.rowid from famovcad t where cod_pac = '3938699'

UPDATE FAMOVCAD SET TIPO_COMANDA = 'DAYH' WHERE COD_PAC = '4000120';
UPDATE FAMOVCAD SET SET_ORI = '0022' WHERE COD_PAC = '4000120';
update famovprd set tipo_comanda = 'DAYH' where comanda in (select comanda from famovcad t where cod_pac = '4000120')

UPDATE FAMOVCAD SET TIPO_COMANDA = 'DAYH' WHERE COmanda = '1475489';
UPDATE FAMOVCAD SET SET_ORI = '0022' WHERE COmanda = '1475489';
update famovprd set tipo_comanda = 'DAYH' where comanda = '1475489'

update famovprd set cod_tabela = "01"
where cod_tabela = ""
and comanda in (select comanda from famovcad where data_mov >= "01/12/2006")
select * from famovprd where cod_tabela = ""
where famovcad.comanda = famovprd.comanda
and famovcad.data_mov = "05/12/2006"
select * from famovprd

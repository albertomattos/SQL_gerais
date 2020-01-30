select cod_pac, data_mov from famovcad, famovprd
where famovcad.comanda = famovprd.comanda
and codigo = "097785" and cod_pro = "000119" and tipo_pgto = "R" and data_mov >= "01/02/2006"
order by famovprd.comanda desc

select count(*) from famovcad, famovprd, fapaccad where fapaccad.cod_pac = famovcad.cod_pac
and famovcad.comanda = famovprd.comanda
and famovprd.tipo_ato = "01"
and famovcad.data_mov between "01/08/2006" and "31/08/2006"
and fapaccad.cod_con = "004"

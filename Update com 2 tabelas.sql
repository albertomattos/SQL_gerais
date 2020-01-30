update famovprd set tipo_pgto = "H"
where famovprd.sequencial in (select famovdestino.sequencial from famovdestino
where famovdestino.cod_fatura = "622495") and tipo_pgto = "D"

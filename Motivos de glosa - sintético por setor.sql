SELECT famovdestino.valor_tot, faprdcad.tipo_prd, fatipcad.descricao, famovprd.quant, sum(famovdestino.valor_tot) soma
FROM famovcad, famovprd, famovdestino, faprdcad, faticcad, fasetcad, fatipcad
WHERE famovprd.comanda = famovcad.comanda
AND famovdestino.sequencial = famovprd.sequencial
AND faprdcad.codigo = famovprd.codigo
AND faticcad.cod_tic = famovprd.tipo_comanda
AND fasetcad.cod_set = famovcad.set_ori
AND faprdcad.tipo_prd = fatipcad.tipo_prd
AND famovcad.tipo_comanda = 'Z1'
AND famovcad.data_hora_dig between "2008-05-15 00:00:00" and "2008-05-31 23:59:59"
and famovcad.req_dev = "D" and famovcad.set_ori = "0061"
ORDER BY famovcad.req_dev, famovcad.set_ori, famovcad.tipo_comanda, fasetcad.descricao, faprdcad.tipo_prd

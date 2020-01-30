SELECT famovcad.set_ori, famovdestino.valor_tot,
       faprdcad.tipo_prd, famovcad.req_dev,
       faprdcad.descricao, famovcad.tipo_comanda,
       faticcad.descricao descricao_2,
       fasetcad.descricao descricao_3,
       fatipcad.descricao descricao_4,
       famovprd.quant, famovprd.codigo,
       famovdestino.valor,
       famovcad.data_hora_dig,
       case when famovcad.Req_dev="R" then "Requisições:" else "Devoluções:" end case_when_famovcad
FROM famovcad famovcad, famovprd famovprd
     , famovdestino famovdestino
     , faprdcad faprdcad, faticcad faticcad
     , fasetcad fasetcad, fatipcad fatipcad
WHERE (famovprd.comanda = famovcad.comanda) AND
      (famovdestino.sequencial = famovprd.sequencial)
       AND (faprdcad.codigo = famovprd.codigo)
       AND
      (faticcad.cod_tic = famovprd.tipo_comanda)
       AND (fasetcad.cod_set = famovcad.set_ori)
       AND (fatipcad.tipo_prd = faprdcad.tipo_prd)
       AND (
      ( famovcad.tipo_comanda IN ('Z1','Z2','Z3','Z4','Z5','Z6','Z7','Z8','Z9') )
       AND ( famovcad.set_ori IN ('0170') )
       AND ( famovcad.req_dev IN ('R','D') )
       AND (    famovcad.data_hora_dig>="2009-10-01 00:00:00" )
       AND (    famovcad.data_hora_dig<="2009-10-31 00:00:00" )
       AND ( faprdcad.tipo_prd IN ('DES','FIO','GAS','MED','LAB','PCT','TAX') )
      )
ORDER BY famovcad.req_dev, famovcad.set_ori,
         famovcad.tipo_comanda,
         fasetcad.descricao, faprdcad.tipo_prd,
         faprdcad.descricao

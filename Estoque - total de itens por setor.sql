SELECT esestcad.cod_prd, esestcad.cod_set, esestcad.cod_barra_int, faprdcad.tipo_prd, esestcad.est_atu, faprdcad.descricao, 
       fasetcad.descricao descricao_2, fatipcad.descricao descricao_3, eslote_validade.validade, 
       eslote_validade.lote, faprdcad.custo_med, esestcad.est_atu * faprdcad.custo_med esestcad_est_atu_f
FROM esestcad esestcad, faprdcad faprdcad, fasetcad fasetcad, fatipcad fatipcad, eslote_validade eslote_validade
WHERE (faprdcad.codigo = esestcad.cod_prd) AND (fasetcad.cod_set = esestcad.cod_set) AND 
      (fatipcad.tipo_prd = faprdcad.tipo_prd) AND (eslote_validade.cod_barra_int = esestcad.cod_barra_int)
       --AND esestcad.cod_set IN ('0302')
       --AND ( esestcad.EST_ATU <> 0 )
ORDER BY esestcad.cod_set, faprdcad.tipo_prd, esestcad.cod_prd

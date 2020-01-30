SELECT faprdcad.codigo, faprdcad.descricao, faprdcad.tipo_prd,
       esmovcad.data_mov,
       esmovcad.tipo_documento,
       esmovite.valor_tot, faprdcad.cod_gcn
FROM faprdcad faprdcad, esmovite esmovite
     , esmovcad esmovcad
WHERE (esmovite.cod_prd = faprdcad.codigo) AND
      (esmovcad.documento = esmovite.documento)
       AND (
      ( esmovcad.data_mov BETWEEN '01/10/2006' AND '31/10/2006' )
       AND ( esmovite.tipo_documento = 'MOV' )
       AND ( faprdcad.cod_gcn = '4110101001' ))

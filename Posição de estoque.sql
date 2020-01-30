SELECT faprdcad.codigo, esmovite.valor, esmovcad.data_mov,
       faprdcad.descricao, esestcad.est_atu,
       esestcad.cod_set, faprdcad.custo_med,
       case when esestcad.est_atu<>'0.0' then esestcad.est_atu*faprdcad.custo_atu else esestcad.est_atu end case_when_esestcad,
       COUNT(*) COUNT_2,
       case when esestcad.est_atu<>'0.0' then esestcad.est_atu*faprdcad.custo_med else esestcad.est_atu end case_when_esestc_2
FROM faprdcad faprdcad, esestcad esestcad
     , esmovite esmovite, esmovcad esmovcad
WHERE (esestcad.cod_prd = faprdcad.codigo) AND
      (esmovite.cod_prd = faprdcad.codigo) AND
      (esmovcad.tipo_documento = esmovite.tipo_documento)
       AND (esmovcad.documento = esmovite.documento)
       AND ( faprdcad.bloqueado = 'N' )
       AND ( faprdcad.tipo_prd = 'FIO' )
       AND ( esestcad.est_atu <> 0 )
--       AND ( faprdcad.lin_mat = 'ESHS' ))
       and esmovcad.data_mov in (select max(b.data_mov)from esmovite a, esmovcad b where a.tipo_documento = b.tipo_documento and a.documento = b.documento
           and a.tipo_documento = 'COM' /*and a.cod_prd = "109454"*/)
GROUP BY faprdcad.codigo, faprdcad.custo_atu,
         faprdcad.descricao, esestcad.est_atu,
         esestcad.cod_set, faprdcad.custo_med,
         esmovite.valor, esmovcad.data_mov
ORDER BY faprdcad.descricao


select * from esmovite a, esmovcad b where a.tipo_documento = b.tipo_documento and a.documento = b.documento
and a.tipo_documento = "COM" and a.cod_prd = "109454"
and data_mov in (select max(b.data_mov)from esmovite a, esmovcad b where a.tipo_documento = b.tipo_documento and a.documento = b.documento
and a.tipo_documento = "COM" and a.cod_prd = "109454")

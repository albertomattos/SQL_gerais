--select t.*, t.rowid from fafeclog t

SELECT FAPRDCAD.DESCRICAO, G.COD_UNI, G.TIPO_DOCUMENTO, G.DOCUMENTO, G.NOTA, G.COD_SET, G.COD_PRD, G. EST_ANTERIOR, G.QUANT, G.COD_BARRA_INT
FROM FAFECLOG G, FAPRDCAD  WHERE G.COD_PRD = FAPRDCAD.CODIGO /*AND G.TIPO_DOCUMENTO = 'lot' */AND G.COD_UNI IN ('      ')
--and g.cod_set = '0440' and g.tipo_documento = 'his'
GROUP BY G.COD_UNI,FAPRDCAD.DESCRICAO, G.TIPO_DOCUMENTO, G.DOCUMENTO, G.NOTA, G.COD_SET, G.COD_PRD, G. EST_ANTERIOR,G.QUANT, G.COD_BARRA_INT
order by 3
--ORDER BY G.COD_SET, DESCRICAO, G.COD_PRD, G.COD_BARRA_INT
select t.*, t.rowid from esprod_set_lote t where --t.data_hora_inc between '01/11/2014' and '02/11/2014'
t.cod_set = '0436' and t.cod_prd  in ('209243','210570','009520','009537')
--order by 2,1

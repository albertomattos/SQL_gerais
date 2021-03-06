SELECT ESCOTITE.COD_PRD, FAPRDCAD.DESCRICAO, ESCOTITE.QUANT, ESCOTITE.COD_FOR, ESFORCAD.FANTASIA, 
       escotite.quant * escotite.preco_pra VALOR_FINAL
--ESCOTITE.PRECO_PRA, ESCOTITE.OBSERVACAO, ESCOTITE.COD_COT

FROM ESCOTITE ESCOTITE, FAPRDCAD FAPRDCAD
     , ESFORCAD ESFORCAD
WHERE (FAPRDCAD.CODIGO = ESCOTITE.COD_PRD) AND 
      (ESFORCAD.COD_FOR = ESCOTITE.COD_FOR) AND (
      ( ESCOTITE.COD_COT = '009269' ))
ORDER BY FAPRDCAD.DESCRICAO, VALOR_FINAL

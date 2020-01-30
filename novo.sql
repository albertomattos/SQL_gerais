SELECT ESMOVITE.COD_PRD, ESMOVITE.QUANT, 
       ESMOVITE.VALOR, ESMOVITE.VALOR_TOT, 
       ESMOVCAD.COD_FOR, ESMOVCAD.DATA_MOV, 
       ESMOVCAD.DOCUMENTO, ESMOVCAD.DESC_FIN, 
       ESMOVCAD.DESC_GER, ESMOVCAD.DESC_GER_VAL, 
       FAPRDCAD.TIPO_PRD, FAPRDCAD.DESCRICAO, 
       ESFORCAD.FANTASIA, 
       FATIPCAD.DESCRICAO DESCRICAO_2
FROM ESMOVCAD ESMOVCAD, ESMOVITE ESMOVITE
     , FAPRDCAD FAPRDCAD, ESFORCAD ESFORCAD
     , FATIPCAD FATIPCAD
WHERE 
      (ESMOVITE.TIPO_DOCUMENTO = ESMOVCAD.TIPO_DOCUMENTO)
       AND (ESMOVITE.DOCUMENTO = ESMOVCAD.DOCUMENTO)
       AND (FAPRDCAD.CODIGO = ESMOVITE.COD_PRD)
       AND (ESFORCAD.COD_FOR = ESMOVCAD.COD_FOR)
       AND (FATIPCAD.TIPO_PRD = FAPRDCAD.TIPO_PRD)
       AND (
      ( ESMOVCAD.DATA_MOV BETWEEN TO_DATE('2012/01/01','YYYY/MM/DD') AND TO_DATE('2012/01/05','YYYY/MM/DD') )
       AND ( ESMOVCAD.TIPO_DOCUMENTO = 'COM' ))
ORDER BY FAPRDCAD.TIPO_PRD, ESMOVCAD.DOCUMENTO, 
         FAPRDCAD.DESCRICAO

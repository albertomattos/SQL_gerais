SELECT ESFORCAD.COD_FOR, ESFORCAD.FANTASIA,FAPRDCAD.DESCRICAO, ESMOVITE.COD_PRD,FAPRDCAD.TIPO_PRD, FAPRDCAD.CUSTO_ATU,FAPRDCAD.CUSTO_MED,
FAPRDCAD.CUS_MEDIND,FAPRDCAD.ESTOQ_DIST, esmovcad.cred_deb, SUM(ESMOVITE.QUANT) AS QTD,
SUM(ESMOVITE.QUANT*ESMOVITE.VALOR) VALORTOT
FROM ESMOVCAD,ESMOVITE,ESFORCAD,FAPRDCAD
WHERE ESMOVCAD.TIPO_DOCUMENTO = ESMOVITE.TIPO_DOCUMENTO AND ESMOVCAD.DOCUMENTO = ESMOVITE.DOCUMENTO
AND ESMOVITE.COD_PRD = FAPRDCAD.CODIGO AND ESMOVCAD.TIPO_DOCUMENTO = 'EMP'
AND ESMOVCAD.COD_FOR = ESFORCAD.COD_FOR 
 AND ESMOVCAD.COD_UNI = '      '  AND ESMOVCAD.DATA_MOV >= TO_DATE('01/12/2017','DD/MM/YYYY')
 AND ESMOVCAD.DATA_MOV <= TO_DATE('20/12/2017','DD/MM/YYYY') 
 GROUP BY ESFORCAD.COD_FOR, ESFORCAD.FANTASIA,FAPRDCAD.DESCRICAO, ESMOVITE.COD_PRD,FAPRDCAD.TIPO_PRD, FAPRDCAD.CUSTO_ATU,FAPRDCAD.CUSTO_MED,
 FAPRDCAD.CUS_MEDIND,FAPRDCAD.ESTOQ_DIST, esmovcad.cred_deb
 HAVING SUM(ESMOVITE.QUANT) <> 0 
 ORDER BY ESFORCAD.FANTASIA,FAPRDCAD.DESCRICAO, ESMOVITE.COD_PRD,FAPRDCAD.TIPO_PRD, FAPRDCAD.CUSTO_ATU,FAPRDCAD.CUSTO_MED,
 FAPRDCAD.CUS_MEDIND,FAPRDCAD.ESTOQ_DIST
 /*
 SELECT SUM(EST_ATU) SOMA FROM ESESTCAD E  WHERE E.COD_PRD = '211846'
 
 SELECT CUSTO_ATU, CUSTO_MED, CUS_MEDIND, ANO_MES FROM ESHISCUS WHERE COD_UNI = ?   AND COD_PRD = ?   AND ANO_MES <= ? ORDER BY ANO_MES*/

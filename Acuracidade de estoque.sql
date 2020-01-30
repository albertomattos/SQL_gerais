SELECT sum(count(*))
FROM ESMOVCAD,ESMOVITE,FAPRDCAD,FATIPCAD,ESSALPRD 
WHERE 
 ESMOVCAD.TIPO_DOCUMENTO = 'BAL' AND ESMOVCAD.DOCUMENTO = ESMOVITE.DOCUMENTO AND ESMOVCAD.TIPO_DOCUMENTO = ESMOVITE.TIPO_DOCUMENTO
 AND ESMOVITE.COD_PRD    = FAPRDCAD.CODIGO AND ESSALPRD.COD_PRD(+) = FAPRDCAD.CODIGO AND ESSALPRD.EH_PRINCIPAL(+) = 'S'
 AND FAPRDCAD.TIPO_PRD  = FATIPCAD.TIPO_PRD AND FATIPCAD.PRE_CLASS = 'MAT' 
 AND ESMOVCAD.DATA_MOV >= TO_DATE('01/08/2017' ,'DD/MM/YYYY')  AND ESMOVCAD.DATA_MOV <= TO_DATE('08/08/2017','DD/MM/YYYY')
and esmovcad.cod_aux in (select t.documento from esbalite t where t.validade >= sysdate)
and faprdcad.bloqueado = 'N'
 GROUP BY ESMOVCAD.COD_AUX, ESMOVCAD.DOCUMENTO, ESMOVCAD.DATA_MOV, ESMOVITE.COD_PRD, ESMOVITE.LOTE,ESMOVITE.COD_FABRICANTE,ESMOVITE.VALOR,
 FAPRDCAD.CODIGO, FAPRDCAD.DESCRICAO, FAPRDCAD.LIN_MAT, FAPRDCAD.TIPO_PRD, FAPRDCAD.UNI_DISTRI, FAPRDCAD.CUSTO_ATU, FAPRDCAD.CUSTO_MED,
 FAPRDCAD.CUS_MEDIND, FATIPCAD.DESCRICAO, ESSALPRD.COD_SAL,ESMOVITE.COD_BARRA_INT 
 ORDER BY ESMOVCAD.DOCUMENTO,ESSALPRD.COD_SAL ,FAPRDCAD.DESCRICAO


/*
 SELECT sum(count(*))
FROM ESMOVCAD,ESMOVITE,FAPRDCAD,FATIPCAD,ESSALPRD 
WHERE 
 ESMOVCAD.TIPO_DOCUMENTO = 'BAL' AND ESMOVCAD.DOCUMENTO = ESMOVITE.DOCUMENTO AND ESMOVCAD.TIPO_DOCUMENTO = ESMOVITE.TIPO_DOCUMENTO
 AND ESMOVITE.COD_PRD    = FAPRDCAD.CODIGO AND ESSALPRD.COD_PRD(+) = FAPRDCAD.CODIGO AND ESSALPRD.EH_PRINCIPAL(+) = 'S'
 AND FAPRDCAD.TIPO_PRD  = FATIPCAD.TIPO_PRD AND FATIPCAD.PRE_CLASS = 'MAT' 
 AND ESMOVCAD.DATA_MOV >= TO_DATE('07/08/2017' ,'DD/MM/YYYY')  AND ESMOVCAD.DATA_MOV <= TO_DATE('07/08/2017','DD/MM/YYYY')
and esmovite.qtd_atendida <> 0
 GROUP BY ESMOVCAD.COD_AUX, ESMOVCAD.DOCUMENTO, ESMOVCAD.DATA_MOV, ESMOVITE.COD_PRD, ESMOVITE.LOTE,ESMOVITE.COD_FABRICANTE,ESMOVITE.VALOR, FAPRDCAD.CODIGO, FAPRDCAD.DESCRICAO, FAPRDCAD.LIN_MAT, FAPRDCAD.TIPO_PRD, FAPRDCAD.UNI_DISTRI, FAPRDCAD.CUSTO_ATU, FAPRDCAD.CUSTO_MED, FAPRDCAD.CUS_MEDIND, FATIPCAD.DESCRICAO, ESSALPRD.COD_SAL,ESMOVITE.COD_BARRA_INT 
 ORDER BY ESMOVCAD.DOCUMENTO,ESSALPRD.COD_SAL ,FAPRDCAD.DESCRICAO */
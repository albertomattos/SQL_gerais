SELECT (SUM(SUM(FAFATPRD.VALOR_TOT)) + SUM(SUM(FAFATPRD.VALOR_TAXA))) TOTAL_FATURADO
FROM FAFATPRD,FAPRDCAD,FATIPCAD,FAPACCAD,FAFATCAD,FASETCAD,FACONCAD,FAPRTCAD,FAPRGCAD,ESGCNCAD
WHERE FAFATPRD.COD_PRD  = FAPRDCAD.CODIGO AND FAPRDCAD.TIPO_PRD = FATIPCAD.TIPO_PRD AND FAFATCAD.FATURA = FAFATPRD.FATURA
AND FAFATPRD.COD_PAC  = FAPACCAD.COD_PAC AND FAFATCAD.COD_CON  = FACONCAD.COD_CON AND FAPACCAD.COD_PRT  = FAPRTCAD.COD_PRT
AND FASETCAD.COD_SET  = FAFATPRD.COD_SET AND FAPRDCAD.COD_GRU  = FAPRGCAD.COD_PRG(+) AND FAPRDCAD.COD_GCN  = ESGCNCAD.COD_GCN(+) 
AND FAFATCAD.DATA_EMISS >= '01/11/2012'  AND FAFATCAD.DATA_EMISS <= '01/11/2012'  AND FAFATPRD.TIPO_PGTO IN ('D','H','R')
AND FAPACCAD.TIP_ATEND IN ('L','M','I','P') AND FAPACCAD.TIPO_PAC IN ('I','E','U','A') AND FAFATCAD.COD_UNI IN ('0001')
GROUP BY FAFATPRD.FATURA

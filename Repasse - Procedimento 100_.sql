SELECT FAFATCAD.FATURA, FAFATCAD.DESTINO, 
       FAPROCAD.NOME_PRO, FAPRDCAD.DESCRICAO, 
       FAPRTCAD.NOME_PAC, FAFATCAD.COD_CON, 
       FACONCAD.FANTASIA, FAPROCAD.PERC_IMPOS, 
       FAPLACAD.NOME_PLANO, 
       FAMOVCAD.COD_PAC COD_PAC_2, 
       FAMOVDESTINO.NUMERO_REPASSE NUMERO_REPASSE_2, 
       FAMOVDESTINO.VALOR_REPASSE VALOR_REPASSE_2, 
       FAMOVPRD.CODIGO, 
       FAMOVPRD.COD_PRO COD_PRO_2, 
       FAMOVDESTINO.VALOR_TOT, FAPROCAD.CRM, 
       FAMOVCAD.DATA_MOV, 
       fafatcad.fatura || fafatcad.destino fafatcad_fatura_fa, 
       /*if faprdcad.tipo_prd in (select tipo_prd from farptcad where cod_pro = '000136')
       (*/
       (famovdestino.valor_tot * ((100 - faprocad.perc_hosp)/100)) -
       ((famovdestino.valor_tot * ((100 - faprocad.perc_hosp)/100)) * 0.102) *
       (1 - (farptcad.perc_hosp_hon/100)) Valor_pago
       /*end if*/
FROM FAFATCAD FAFATCAD, FACONCAD FACONCAD
     , FAFATPRD FAFATPRD, FAPRDCAD FAPRDCAD
     , FAPROCAD FAPROCAD, FAPACCAD FAPACCAD
     , FAPRTCAD FAPRTCAD, FAPLACAD FAPLACAD
     , FAMOVCAD FAMOVCAD, FAMOVPRD FAMOVPRD
     , FAMOVDESTINO FAMOVDESTINO
     , FATIPCAD FATIPCAD, farptcad, farpicad
WHERE (FACONCAD.COD_CON = FAFATCAD.COD_CON) AND 
      (FAFATPRD.FATURA = FAFATCAD.FATURA) AND 
      (FAPRDCAD.CODIGO = FAFATPRD.COD_PRD) AND 
      (FAPRDCAD.CODIGO = FAMOVPRD.CODIGO) AND
      (FAPROCAD.COD_PRO = FAFATPRD.COD_PRO) AND 
      (FAPACCAD.COD_PAC = FAFATPRD.COD_PAC) AND 
      (FAPRTCAD.COD_PRT = FAPACCAD.COD_PRT) AND 
      (FAPLACAD.COD_CON = FAPACCAD.COD_CON)
       AND (FAPLACAD.COD_PLA = FAPACCAD.COD_PLA)
       AND (FAMOVCAD.COD_PAC = FAPACCAD.COD_PAC)
       AND (FAMOVPRD.COMANDA = FAMOVCAD.COMANDA)
       AND (FAMOVPRD.TIPO_COMANDA = FAMOVCAD.TIPO_COMANDA)
       AND 
      (FAMOVDESTINO.SEQUENCIAL = FAMOVPRD.SEQUENCIAL)
       AND (FATIPCAD.TIPO_PRD = FAPRDCAD.TIPO_PRD)
       AND (FAFATPRD.COD_PRO = FAMOVPRD.COD_PRO)
       and farptcad.cod_pro = faprocad.cod_pro
       and farpicad.cod_pro =faprocad.cod_pro
       and famovprd.cod_pro = farpicad.cod_pro
       and famovprd.cod_pro = farptcad.cod_pro
       and farpicad.cod_pro = farptcad.cod_pro
       AND (
      ( FAMOVDESTINO.NUMERO_REPASSE IS NOT NULL  )
       AND ( FAMOVDESTINO.NUMERO_REPASSE = 61 )
       and faprocad.cod_pro = '000206'
       AND ( FATIPCAD.REPASSAVEL = 'S' ))
ORDER BY FAPROCAD.NOME_PRO, FAPRDCAD.DESCRICAO, 
         FAPRTCAD.NOME_PAC, FAMOVCAD.DATA_MOV

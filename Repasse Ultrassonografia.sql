SELECT FAFATCAD.FATURA, FAFATCAD.DESTINO, 
       FAPROCAD.NOME_PRO, FAPRDCAD.CODIGO,FAPRDCAD.DESCRICAO, 
       FAPRTCAD.NOME_PAC, FAFATCAD.COD_CON, 
       FACONCAD.FANTASIA, FAPROCAD.PERC_IMPOS, 
       FAPLACAD.NOME_PLANO, 
       FAMOVCAD.COD_PAC COD_PAC_2, 
       FAMOVDESTINO.NUMERO_REPASSE NUMERO_REPASSE_2, 
       FAMOVDESTINO.VALOR_REPASSE VALOR_REPASSE_2, 
       FAMOVPRD.COD_PRO COD_PRO_2, FAPROCAD.CRM, 
       FAMOVCAD.DATA_MOV, 
       fafatcad.fatura || fafatcad.destino fafatcad_fatura_fa, 
       (fafatprd.valor_honorario + fafatprd.valor_filme + fafatprd.valor_custo_oper) valor,
       ((fafatcad.valor_pago/fafatcad.valor_guia)) PERCpago,
       ((fafatcad.valor_pago/fafatcad.valor_guia)*(fafatprd.valor_honorario + fafatprd.valor_filme + fafatprd.valor_custo_oper)) famovdestino_valo,
       (((fafatcad.valor_pago/fafatcad.valor_guia)*(fafatprd.valor_honorario + fafatprd.valor_filme + fafatprd.valor_custo_oper)) * 0.95) VALOR_FINAL
       
FROM FAFATCAD FAFATCAD, FACONCAD FACONCAD
     , FAFATPRD FAFATPRD, FAPRDCAD FAPRDCAD
     , FAPROCAD FAPROCAD, FAPACCAD FAPACCAD
     , FAPRTCAD FAPRTCAD, FAPLACAD FAPLACAD
     , FAMOVCAD FAMOVCAD, FAMOVPRD FAMOVPRD
     , FAMOVDESTINO FAMOVDESTINO
     , FATIPCAD FATIPCAD
WHERE (FACONCAD.COD_CON = FAFATCAD.COD_CON) AND 
      (FAFATPRD.FATURA = FAFATCAD.FATURA) AND 
      (FAPRDCAD.CODIGO = FAFATPRD.COD_PRD) AND 
      (FAPROCAD.COD_PRO = FAFATPRD.COD_PRO) AND 
      (FAPACCAD.COD_PAC = FAFATPRD.COD_PAC) AND 
      (FAPRTCAD.COD_PRT = FAPACCAD.COD_PRT) AND 
      (FAPLACAD.COD_CON = FAPACCAD.COD_CON)
       AND (FAPLACAD.COD_PLA = FAPACCAD.COD_PLA)
       AND (FAMOVCAD.COD_PAC = FAPACCAD.COD_PAC)
       AND (FAMOVPRD.COMANDA = FAMOVCAD.COMANDA)
       AND (FAMOVPRD.TIPO_COMANDA = FAMOVCAD.TIPO_COMANDA)
       AND (FAMOVPRD.CODIGO = FAPRDCAD.CODIGO)
       AND (FAMOVDESTINO.SEQUENCIAL = FAMOVPRD.SEQUENCIAL)
       AND (FATIPCAD.TIPO_PRD = FAPRDCAD.TIPO_PRD)
       AND (FAFATPRD.COD_PRO = FAMOVPRD.COD_PRO)
       AND (
      ( FAMOVDESTINO.NUMERO_REPASSE IS NOT NULL  )
       AND ( FAMOVDESTINO.NUMERO_REPASSE = 61 )
       AND ( FATIPCAD.REPASSAVEL = 'S' ))
ORDER BY FAPROCAD.NOME_PRO, FAPRDCAD.DESCRICAO, FAMOVPRD.CODIGO, 
         FAPRTCAD.NOME_PAC, FAMOVCAD.DATA_MOV
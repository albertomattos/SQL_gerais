SELECT famovFAPROCAD.NOME_PRO, FAPRDCAD.DESCRICAO, FAPRTCAD.NOME_PAC, FACONCAD.FANTASIA, FAPROCAD.PERC_IMPOS, FAMOVCAD.COD_PAC COD_PAC_2,
       FAMOVDESTINO.NUMERO_REPASSE REPASSE, FAMOVDESTINO.VALOR_REPASSE VALOR_REPASSE, FAMOVPRD.CODIGO, 
       FAMOVPRD.COD_PRO COD_PRO_2, FAMOVDESTINO.VALOR_TOT, FAPROCAD.CRM, FAMOVCAD.DATA_MOV, 
       fafatcad.fatura || fafatcad.destino fafatcad_fatura_fa
FROM FAFATCAD FAFATCAD, FACONCAD FACONCAD, FAFATPRD FAFATPRD, FAPRDCAD FAPRDCAD, FAPROCAD FAPROCAD, FAPACCAD FAPACCAD
     , FAPRTCAD FAPRTCAD, FAPLACAD FAPLACAD, FAMOVCAD FAMOVCAD, FAMOVPRD FAMOVPRD, FAMOVDESTINO FAMOVDESTINO, FATIPCAD FATIPCAD
WHERE (FACONCAD.COD_CON = FAFATCAD.COD_CON) AND (FAFATPRD.FATURA = FAFATCAD.FATURA) AND (FAPRDCAD.CODIGO = FAFATPRD.COD_PRD) AND 
      (FAPROCAD.COD_PRO = FAFATPRD.COD_PRO) AND (FAPACCAD.COD_PAC = FAFATPRD.COD_PAC) AND (FAPRTCAD.COD_PRT = FAPACCAD.COD_PRT) AND 
      (FAPLACAD.COD_CON = FAPACCAD.COD_CON) AND (FAPLACAD.COD_PLA = FAPACCAD.COD_PLA) AND (FAMOVCAD.COD_PAC = FAPACCAD.COD_PAC)
       AND (FAMOVPRD.COMANDA = FAMOVCAD.COMANDA) AND (FAMOVPRD.TIPO_COMANDA = FAMOVCAD.TIPO_COMANDA)
       AND (FAMOVDESTINO.SEQUENCIAL = FAMOVPRD.SEQUENCIAL) AND (FATIPCAD.TIPO_PRD = FAPRDCAD.TIPO_PRD)
       AND (FAFATPRD.COD_PRO = FAMOVPRD.COD_PRO) AND (( FAMOVDESTINO.NUMERO_REPASSE IS NOT NULL  )
--       AND ( FAMOVDESTINO.NUMERO_REPASSE = 61 )
       AND ( FATIPCAD.REPASSAVEL = 'S' ))
       AND ( FAPROCAD.COD_PRO = '151767' )
       and famovcad.data_mov between '01/02/2017' and '10/02/2017'
ORDER BY FAPROCAD.NOME_PRO, FAPRDCAD.DESCRICAO, 
         FAPRTCAD.NOME_PAC, FAMOVCAD.DATA_MOV


-------------------
SELECT FAPACCAD.DATA_ENT, FAPROCAD.NOME_PRO, FAPROCAD.COD_PRO, FAPRTCAD.NOME_PAC, FAPRDCAD.DESCRICAO, FACONCAD.FANTASIA, 
  FAMOVDESTINO.VALOR_TOT, FAPACCAD.COD_PAC, case famovprd.tipo_pgto when 'N' then famovdestino.valor_tot*0 else famovdestino.valor_tot
  end valor_pago, famovdestino.valor, famovcad.
  FROM FAPRTCAD FAPRTCAD, FAPACCAD FAPACCAD, FAMOVCAD FAMOVCAD, FAMOVPRD FAMOVPRD, FAMOVDESTINO FAMOVDESTINO
     , FACONCAD FACONCAD, FAPROCAD FAPROCAD, FAPRDCAD FAPRDCAD WHERE (FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT) AND 
      (FAMOVCAD.COD_PAC = FAPACCAD.COD_PAC) AND (FAMOVPRD.TIPO_COMANDA = FAMOVCAD.TIPO_COMANDA) AND (FAMOVPRD.COMANDA = FAMOVCAD.COMANDA)
       AND (FAMOVDESTINO.SEQUENCIAL = FAMOVPRD.SEQUENCIAL) AND (FACONCAD.COD_CON = FAPACCAD.COD_CON)
       AND (FAPROCAD.COD_PRO = FAMOVPRD.COD_PRO) AND (FAPRDCAD.CODIGO = FAMOVPRD.CODIGO) AND (
      ( FAPACCAD.DATA_ENT BETWEEN TO_DATE('2017/02/06','YYYY/MM/DD') AND TO_DATE('2017/02/10','YYYY/MM/DD') )
       AND ( FAPRDCAD.TIPO_PRD = 'PRO' )) and faprocad.cod_pro = '151767'
ORDER BY FAPROCAD.NOME_PRO, FAPACCAD.DATA_ENT, FAPRTCAD.NOME_PAC

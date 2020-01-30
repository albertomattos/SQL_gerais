SELECT FAPACCAD.COD_PRO_SA, FAPROCAD.NOME_PRO, count(FAPROCAD.NOME_PRO)
FROM FAPACCAD FAPACCAD, FAPROCAD FAPROCAD
     , IMMOVCAD IMMOVCAD, IMMOVPRD IMMOVPRD
     , FAPRDCAD FAPRDCAD, FATIPCAD FATIPCAD
WHERE (FAPROCAD.COD_PRO = FAPACCAD.COD_PRO_SA)
       AND (IMMOVCAD.COD_PAC = FAPACCAD.COD_PAC)
       AND (IMMOVPRD.COMANDA = IMMOVCAD.COMANDA)
       AND (IMMOVPRD.TIPO_COMANDA = IMMOVCAD.TIPO_COMANDA)
       AND (FAPRDCAD.CODIGO = IMMOVPRD.COD_PRD)
       AND (FATIPCAD.TIPO_PRD = FAPRDCAD.TIPO_PRD) and fatipcad.tipo_prd in ('RAD','REM','TOM','END','USG')
       AND (
      ( FAPACCAD.DATA_ENT BETWEEN TO_DATE('2012/06/01','YYYY/MM/DD') AND TO_DATE('2012/06/30','YYYY/MM/DD') )
       )
--       AND ( FAPACCAD.TIPO_PAC = 'U' ))
GROUP BY FAPACCAD.COD_PRO_SA, FAPROCAD.NOME_PRO
ORDER BY FAPROCAD.NOME_PRO

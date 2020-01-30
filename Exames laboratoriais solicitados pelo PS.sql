SELECT DISTINCT (decode(FAPACCAD.COD_ALA,'PSCM','Clínica Médica','PSGO','Ginecologia', 'PSPE','Pediatria',
'PSOR','Ortopedia','PSCA','Cardiologia','PSCG','Cirurgia Geral')) Clinica,
COUNT(fapaccad.cod_ala)
  FROM ITEM_SOL_EXA JOIN FAPACCAD ON ITEM_SOL_EXA.COD_PAC = FAPACCAD.COD_PAC
  JOIN FAPRDCAD ON FAPRDCAD.CODIGO = ITEM_SOL_EXA.CODIGO
  INNER JOIN SOL_EXAME ON ITEM_SOL_EXA.COD_PAC = SOL_EXAME.COD_PAC 
  AND ITEM_SOL_EXA.DAT_SOLICITACAO = SOL_EXAME.DAT_SOLICITACAO
  inner join faprocad on sol_exame.cod_pro_solic = faprocad.cod_pro 
  LEFT JOIN LBMATCAD ON ITEM_SOL_EXA.COD_MAT_COLETA = LBMATCAD.COD_MAT_COLETA
  LEFT JOIN URCIDCAD ON ITEM_SOL_EXA.FK_UR_CID      = URCIDCAD.PK_UR_CID
  inner join fapaccad on SOL_EXAME.COD_PAC = fapaccad.cod_pac
WHERE fapaccad.data_ent > '01/01/2018' and fapaccad.tipo_pac = 'U' and faprdcad.tipo_prd in ('LAB','MEN')
group by fapaccad.cod_ala

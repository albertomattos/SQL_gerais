SELECT U.NOME, COUNT(*) AS CONTAGEM FROM  IMMOVPRD ED, IMMOVCAD E, FAPACCAD P, FAPRDCAD PD,
FAUSUCAD U WHERE ED.COD_PRD = PD.CODIGO AND ED.COMANDA = E.COMANDA AND ED.TIPO_COMANDA = E.TIPO_COMANDA
AND ED.COD_UNI = E.COD_UNI AND E.COD_PAC = P.COD_PAC AND ED.USU_DIG_LAUDO = U.APELIDO
 AND (ED.DT_DIG_LAUDO BETWEEN '01/09/2015' AND '01/09/2015') 
 GROUP BY   ED.USU_DIG_LAUDO, U.NOME, UD.NOME_UNI ORDER BY ED.USU_DIG_LAUDO

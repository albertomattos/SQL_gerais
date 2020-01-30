SELECT P.COD_PROTOCOLO, a.cod_pac, b.nome_pac, D.documento fatura, FAT.Valor_Tot, CON.Fantasia convenio
FROM protocolo P, item_protocolo I, Fadocumentos D, fafatcad FAT, faconcad CON, fapaccad a, faprtcad b
WHERE I.cod_protocolo = P.cod_protocolo 
AND D.SEQUENCIAL = I.SEQUENCIAL  
AND D.DOCUMENTO = FAT.FATURA AND FAT.Cod_Con = CON.COD_CON
and FAT.Cod_Pac = a.cod_pac
and a.cod_prt = b.cod_prt
ORDER BY P.COD_PROTOCOLO, b.nome_pac

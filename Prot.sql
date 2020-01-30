SELECT PRT.nome_pac PACIENTE, D.cod_pac REGISTRO,
(SELECT descricao FROM fasetcad WHERE cod_set = P.cod_setor_remesa ) setor_origem, 
(SELECT descricao FROM fasetcad WHERE cod_set = P.cod_setor_destino) setor_destino, 
(SELECT apelido FROM fausucad WHERE matricula = P.nom_usuario_remet) remetente, P.dat_remessa DATA_ENVIO, I.dat_recebimento, 
        D.documento FATURA,
(SELECT apelido FROM fausucad WHERE matricula = I.cod_usuario_receb) usu_destinatario, FAT.Valor_Tot,
CON.Fantasia CONVENIO

FROM protocolo P, item_protocolo I, Fadocumentos D, faprtcad PRT, tipo_documento TD, famotivo_envio ME, fapaccad PAC, fafatcad FAT,
faconcad CON

WHERE I.cod_protocolo = P.cod_protocolo 
AND D.SEQUENCIAL = I.SEQUENCIAL  
AND PAC.cod_pac = D.cod_pac 
AND PRT.cod_prt = PAC.cod_prt 
AND TD.cod_tipo_documento = D.cod_tipo_documento 
AND ME.cod_motivo_env = I.cod_motivo_env
AND D.DOCUMENTO = FAT.FATURA AND FAT.Cod_Con = CON.COD_CON
AND P.dat_remessa >= TO_DATE('01/03/2014 00:00','DD/MM/YYYY HH24:MI')  AND P.dat_remessa <= TO_DATE('20/03/2014 23:59','DD/MM/YYYY HH24:MI')  
ORDER BY P.dat_remessa, PRT.cod_prt, PRT.nome_pac, D.cod_pac

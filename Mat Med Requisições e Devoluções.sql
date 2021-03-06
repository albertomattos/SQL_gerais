--No Esthos, Relatórios, Requisições/Devoluções internas, Levantamento Estatístico.
SELECT count(distinct ESMOVCAD.DOCUMENTO)
FROM ESMOVCAD,ESMOVITE,FAPRDCAD WHERE ESMOVCAD.TIPO_DOCUMENTO = ESMOVITE.TIPO_DOCUMENTO
AND ESMOVITE.COD_PRD = FAPRDCAD.CODIGO AND ESMOVCAD.DOCUMENTO = ESMOVITE.DOCUMENTO AND ESMOVCAD.TIPO_DOCUMENTO = 'REQ'
AND ESMOVCAD.DATA_MOV >= '01/09/2017' AND ESMOVCAD.DATA_MOV <= '30/09/2017'
AND FAPRDCAD.TIPO_PRD IN ('MED','MQU','FIO','DES','FNU','INS') AND ESMOVCAD.CRED_DEB = 'D'
GROUP BY ESMOVCAD.DOCUMENTO, ESMOVITE.COD_PRD
/*
SELECT count(count(ESMOVCAD.DOCUMENTO))
FROM ESMOVCAD,ESMOVITE,FAPRDCAD WHERE ESMOVCAD.TIPO_DOCUMENTO = ESMOVITE.TIPO_DOCUMENTO
AND ESMOVITE.COD_PRD = FAPRDCAD.CODIGO AND ESMOVCAD.DOCUMENTO = ESMOVITE.DOCUMENTO AND ESMOVCAD.TIPO_DOCUMENTO = 'REQ'
AND ESMOVCAD.DATA_MOV >= '01/09/2017' AND ESMOVCAD.DATA_MOV <= '30/09/2017'
AND FAPRDCAD.TIPO_PRD IN ('MED','MQU','FIO','DES','FNU','INS') AND ESMOVCAD.CRED_DEB = 'D'
GROUP BY ESMOVCAD.DOCUMENTO, ESMOVITE.COD_PRD*/

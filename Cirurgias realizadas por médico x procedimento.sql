SELECT distinct blciru_realizada.cod_pac, NOME_PRO, COD_PRO, FAPRDCAD.DESCRICAO PROCEDIMENTO
FROM BLCIRU_REALIZADA, BLSTAT_CIRU_REZD, BLCIRU_STATUS, BLPROC_CIRURGICO, FAPRDCAD, FAPROCAD, BLEQPE_PROC_CIRU
WHERE  BLCIRU_REALIZADA.CD_CIRU_REALIZADA = BLSTAT_CIRU_REZD.CD_CIRU_REALIZADA
AND  BLSTAT_CIRU_REZD.CD_CIRU_STATUS      = BLCIRU_STATUS.CD_CIRU_STATUS
AND  BLCIRU_REALIZADA.CD_CIRU_REALIZADA   = BLPROC_CIRURGICO.CD_CIRU_REALIZADA
AND  BLPROC_CIRURGICO.CD_PROC_CIRURGICO   = FAPRDCAD.CODIGO
AND  BLPROC_CIRURGICO.CD_PROC_CIRURGICO   = BLEQPE_PROC_CIRU.CD_PROC_CIRURGICO
AND  BLPROC_CIRURGICO.CD_CIRU_REALIZADA   = BLEQPE_PROC_CIRU.CD_CIRU_REALIZADA
AND  BLPROC_CIRURGICO.REGIAO              = BLEQPE_PROC_CIRU.REGIAO
AND  BLEQPE_PROC_CIRU.CD_PROFISSIONAL     = FAPROCAD.COD_PRO
AND  BLEQPE_PROC_CIRU.COD_ATO IN ('01')
AND  BLCIRU_STATUS.CD_CIRU_STATUS = 'E'
--AND  BLPROC_CIRURGICO.DATA_HORA_INI IS NOT NULL
--AND  BLPROC_CIRURGICO.DATA_HORA_FIM IS NOT NULL
AND BLPROC_CIRURGICO.DATA_HORA_INI >= '01/05/2012'
AND BLPROC_CIRURGICO.DATA_HORA_FIM <= '01/06/2012'
ORDER BY COD_PRO, FAPRDCAD.DESCRICAO

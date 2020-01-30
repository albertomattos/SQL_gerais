SELECT FAPRDCAD.CODIGO,FAPRDCAD.TIPO_PRD, FAPRDCAD.CUSTO_ATU, FAPRDCAD.ESTOQ_DIST, FAPRDCAD.DESCRICAO DESC_PRD,
FAPRDCAD.UNI_DISTRI, FAPRDCAD.PCT_TAXA_ADMIN, FAPRDCAD.GRU_EST, FATIPCAD.PRE_CLASS,
FAMOVCAD.DATA_MOV, TO_CHAR(FAMOVCAD.HORA_MOV,'HH24:MI') HORA_MOV , FAMOVCAD.COD_PAC,
SUM(FAMOVPRD.QUANT * DECODE(REQ_DEV,'R',1,-1) / (SELECT COUNT(*) FROM FAMOVDESTINO WHERE SEQUENCIAL = FAMOVPRD.SEQUENCIAL
AND FAMOVDESTINO.DESTINO IN ('H','C','P'))) AS QTD_PER,SUM(FAMOVDESTINO.VALOR_TOT * DECODE(REQ_DEV,'R',1,-1)) AS VAL_PER, 0
AS HONORARIO, 0 AS HONORARIO_CBHPM, 0 AS FILME, 0 AS CUSTO_OPER, 0 AS CUSTO_OPER_CBHPM  FROM FAMOVDESTINO, FATIPCAD, FASETCAD,
FAPRDCAD, FAPACCAD, FAMOVCAD, FAMOVPRD, FAPRTCAD
WHERE /*(FAMOVPRD.TIPO_PGTO <> :1 OR  FAMOVPRD.TIPO_PGTO IS NULL
OR  FAMOVPRD.TIPO_PGTO = :2 OR  FAMOVPRD.TIPO_PGTO = 'H')
AND */FAMOVCAD.DATA_MOV >= '01/06/2011'  AND FAMOVCAD.DATA_MOV <= '30/06/2011'
AND FAMOVCAD.SET_ORI  IN ('0429','0430','0432','0433','0431','0454','0312','0435','0132','0133','0134','0191','0130','0459','0453')
AND FAMOVDESTINO.DESTINO IN ('H','C','P') AND FAPRDCAD.TIPO_PRD  IN ('FIO','MAT','MED','OPS') AND FAPACCAD.TIPO_PAC IN ('I')
AND fapaccad.cod_uni IN ('0001') AND FAMOVDESTINO.SEQUENCIAL = FAMOVPRD.SEQUENCIAL  AND FAMOVPRD.TIPO_COMANDA = FAMOVCAD.TIPO_COMANDA
AND FAMOVPRD.COMANDA  = FAMOVCAD.COMANDA AND FAMOVPRD.CODIGO   = FAPRDCAD.CODIGO AND FAPACCAD.COD_PRT  = FAPRTCAD.COD_PRT
AND FAMOVCAD.COD_PAC  = FAPACCAD.COD_PAC AND FAPRDCAD.TIPO_PRD = FATIPCAD.TIPO_PRD AND FAMOVCAD.SET_ORI  = FASETCAD.COD_SET
GROUP BY  FAPRDCAD.CODIGO,FAPRDCAD.TIPO_PRD , FAPRDCAD.CUSTO_ATU, FAPRDCAD.ESTOQ_DIST, FAPRDCAD.DESCRICAO, FAPRDCAD.UNI_DISTRI,
FAPRDCAD.PCT_TAXA_ADMIN, FAPRDCAD.GRU_EST, FATIPCAD.PRE_CLASS , FAMOVCAD.DATA_MOV, FAMOVCAD.HORA_MOV , FAMOVCAD.COD_PAC

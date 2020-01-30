/*CREATE TABLE HISTORICO_CUSTO (COD_PRD VARCHAR2(6), ANO_MES VARCHAR2(6));
--DROP TABLE HISTORICO_CUSTO

INSERT INTO HISTORICO_CUSTO SELECT COD_PRD, MAX(ANO_MES) FROM ESHISCUS WHERE ANO_MES <= '201301' GROUP BY COD_PRD;
SELECT * FROM HISTORICO_CUSTO;*/

SELECT FASETCAD.COD_SET, FASETCAD.DESCRICAO, FAPRDCAD.TIPO_PRD, FATIPCAD.DESCRICAO DESC_TIPO, FAPRDCAD.CODIGO,
FAPRDCAD.DESCRICAO, FAPRDCAD.UNI_ESTOQU, SUM(ESHISCON.QTD_CONSUMO) QTD,
SUM(ESHISCON.QTD_CONSUMO * ESHISCUS.CUSTO_ATU) CUSTO_ATU,SUM(ESHISCON.QTD_CONSUMO * ESHISCUS.CUSTO_MED) CUSTO_MED
FROM FAPRDCAD, FATIPCAD, ESHISCON, FASETCAD, FACELCAD, ESHISCUS,HISTORICO_CUSTO
WHERE FAPRDCAD.TIPO_PRD = FATIPCAD.TIPO_PRD AND FATIPCAD.PRE_CLASS = 'MAT' AND FAPRDCAD.CODIGO  = ESHISCON.COD_PRD
AND FASETCAD.COD_SET = ESHISCON.COD_SET AND FASETCAD.COD_CEL = FACELCAD.COD_CEL(+) AND HISTORICO_CUSTO.COD_PRD = ESHISCON.COD_PRD
AND ESHISCUS.COD_PRD = HISTORICO_CUSTO.COD_PRD AND ESHISCUS.ANO_MES = HISTORICO_CUSTO.ANO_MES AND ESHISCON.COD_UNI = ESHISCUS.COD_UNI
AND ESHISCON.COD_UNI = '      ' AND ESHISCON.ANO_MES = '201301' 
--AND FAPRDCAD.GRU_EST  IN ('STI') 
and faprdcad.codigo = '202521'
GROUP BY FASETCAD.COD_SET, FASETCAD.DESCRICAO, FAPRDCAD.TIPO_PRD, FATIPCAD.DESCRICAO, FAPRDCAD.CODIGO,
FAPRDCAD.DESCRICAO, FAPRDCAD.UNI_ESTOQU
ORDER BY FASETCAD.COD_SET,FAPRDCAD.TIPO_PRD,FAPRDCAD.CODIGO
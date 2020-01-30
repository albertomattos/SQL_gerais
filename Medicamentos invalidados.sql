SELECT PRESCRICAO_PAC.SEQUENCIAL, PRESCRICAO_PAC.COD_PAC, PRESCRICAO_PAC.LEITO, PRESCRICAO_PAC.COD_SET, PRESCRICAO_PAC.FK_MATRICULA_VALID,
PRESCRICAO_PAC.ITEM_VALIDO, PRESCRICAO_PAC.DATA_PRESCRICAO, PRESCRICAO_PAC.CODIGO FROM PRESCRICAO_PAC, faprdcad WHERE prescricao_pac.codigo
= faprdcad.codigo
AND PRESCRICAO_PAC.DATA_PRESCRICAO >= TO_DATE('21/12/2017','DD/MM/YYYY')
AND PRESCRICAO_PAC.DATA_PRESCRICAO <= TO_DATE('31/12/2017','DD/MM/YYYY')
and faprdcad.tipo_prd in ('MED','MQU') and item_valido in ('I')
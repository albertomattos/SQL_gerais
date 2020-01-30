SELECT SUM(ROUND(To_Char(CT.DATA_INI_ANEST - RS.HORA_INICIAL)*1*24*60)) AS TEMP_MIN_ATRAS_PROC
FROM CTRL_HOR_PROF_CC CT, RCRSVCAD RS, FAPROCAD FA WHERE CT.COD_RSV=RS.COD_RSV AND RS.COD_PRO=FA.COD_PRO AND RS.MOT_CANCELAMENTO IS NULL
AND ROUND(To_Char(CT.DATA_INI_ANEST - RS.HORA_INICIAL)*1*24*60) > 0
AND RS.DATA_INICIAL>=to_date('01/04/2016','dd/mm/yyyy') AND RS.DATA_INICIAL<=to_date('30/04/2016','dd/mm/yyyy')

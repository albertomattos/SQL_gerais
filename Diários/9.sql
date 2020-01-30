SELECT FAPACCAD.DATA_ENT, count(*)
FROM FAPACCAD FAPACCAD, FAPACCOM FAPACCOM
     , FAPRTCAD FAPRTCAD
WHERE (FAPACCOM.COD_PAC = FAPACCAD.COD_PAC) AND 
      (FAPRTCAD.COD_PRT = FAPACCAD.COD_PRT) AND (
      fapaccad.data_ent = &data_ent
--      ( FAPACCAD.DATA_ENT BETWEEN TO_DATE('2012/11/01','YYYY/MM/DD') AND TO_DATE('2012/05/31','YYYY/MM/DD') )
       AND ( FAPACCOM.COD_PCN = 'PS' )
       AND ( FAPACCAD.TIPO_PAC = 'I' ))
group by fapaccad.data_ent
ORDER BY FAPACCAD.DATA_ENT

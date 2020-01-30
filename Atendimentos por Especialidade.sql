SELECT FAESPCAD.COD_ESP, FAESPCAD.DESCRICAO, fapaccad.tipo_pac, COUNT(*) COUNT_2
FROM FAPACCAD FAPACCAD, FAESPCAD FAESPCAD
WHERE (FAESPCAD.COD_ESP = FAPACCAD.COD_ESP) AND (
      FAPACCAD.DATA_ENT BETWEEN '01/01/2014' and '10/01/2014'--&data_ent AND &data_ent )
       /*AND ( FAPACCAD.TIPO_PAC = 'A' )*/)
GROUP BY FAESPCAD.COD_ESP, FAESPCAD.DESCRICAO, fapaccad.tipo_pac
ORDER BY 3 DESC, FAESPCAD.DESCRICAO

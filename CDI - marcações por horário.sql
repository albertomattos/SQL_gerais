SELECT (case when to_char(a.HORA_ENT,'HH24') between '00' and '05' then '00:00 a 05:59'
            when to_char(a.HORA_ENT,'HH24') between '06' and '11' then '06:00 a 11:59'
            when to_char(a.HORA_ENT,'HH24') between '12' and '17' then '12:00 a 17:59'
            when to_char(a.HORA_ENT,'HH24') between '18' and '23' then '18:00 a 23:59'
            end) hora, count(a.cod_ala), FAALACAD.DESCRICAO
FROM FAPACCAD a, FAALACAD
WHERE a.DATA_ENT >= '01/09/2013' AND a.DATA_ENT <= '02/09/2013' AND FAALACAD.COD_ALA = a.COD_ALA
AND a.HORA_ENT IS NOT NULL  AND  a.TIPO_PAC = 'E' and faalacad.descricao like 'CDI%'
group by to_char(a.HORA_ENT,'HH24'), a.COD_ALA, FAALACAD.DESCRICAO

SELECT case when to_char(a.HORA_ENT,'HH24:MI') between '00:00' and '05:59' then '00:00 a 05:59'
            when to_char(a.HORA_ENT,'HH24:MI') between '06:00' and '11:59' then '06:00 a 11:59'
            when to_char(a.HORA_ENT,'HH24:MI') between '12:00' and '17:59' then '12:00 a 17:59'
            when to_char(a.HORA_ENT,'HH24:MI') between '18:00' and '23:59' then '18:00 a 23:59'
            end hora, to_char(a.HORA_ENT,'HH24:MI'), count(a.cod_ala), a.COD_ALA, FAALACAD.DESCRICAO
FROM FAPACCAD a, FAALACAD
WHERE a.DATA_ENT >= '01/09/2013' AND a.DATA_ENT <= '02/09/2013' AND FAALACAD.COD_ALA = a.COD_ALA
AND a.HORA_ENT IS NOT NULL  AND  a.TIPO_PAC IN ('X','X','U','X')  AND a.COD_UNI IN ('0001')
group by a.hora_ent, a.COD_ALA, FAALACAD.DESCRICAO

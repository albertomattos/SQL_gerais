select cod_ala, cod_con, count(*) from fapaccad
where tip_atend = 'I' and data_ent between '26/04/2016' and '27/04/2016'-- and cod_ala = "ORTO"
--and cod_con = "004"
group by cod_ala, cod_con


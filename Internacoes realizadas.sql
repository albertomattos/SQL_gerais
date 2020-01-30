select data_ent, count(*) from fapaccad where tip_atend = "L" and data_ent between "01/07/2004" and "01/08/2004"
and tipo_pac = "I"
group by data_ent order by data_ent


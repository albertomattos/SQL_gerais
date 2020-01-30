select data_ent, count(*) from fapaccad where tipo_pac = "I" and data_ent between "01/09/2005" and "30/09/2005"
group by data_ent order by data_ent


select cod_pac, tipo_pac, data_ent, cod_con, cod_pla, num_guia, matricula
from fapaccad
where data_ent > "01/04/2005"
and num_guia is null
and tipo_pac = "A"
and cod_con = "018"
order by data_ent


select g.*
from faguicad g, fapaccad p
where g.cod_pac = p.cod_pac
and p.tipo_pac = "I"
and p.data_ent = "20/04/2007" and g.tipo_guia = "13"

update faguicad set data_emissao = "2007-04-24 00:00:00"
where cod_pac in (select cod_pac from fapaccad where data_ent = "24/04/2007" and tipo_pac = "U")

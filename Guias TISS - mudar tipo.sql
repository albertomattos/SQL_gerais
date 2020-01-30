--Utilizar via telnet, para atualizar as guias
unload to atu_gia.sql delimiter ";"
select
"UPDATE faguicad set tipo_guia = '13' where tipo_guia='"||
g.tipo_guia||
"' and cod_pac='"||g.cod_pac||"'"
from faguicad g, fapaccad p
where g.cod_pac = p.cod_pac
and p.tipo_pac = "U"
and p.data_ent >= "16/04/2007" and g.tipo_guia <> "13"

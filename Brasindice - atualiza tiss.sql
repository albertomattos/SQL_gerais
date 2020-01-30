select codigo, cod_bras, cod_bras_tiss from faprdcad where tipo_prd = "MED" and cod_bras_tiss <> "" order by cod_bras_tiss

unload to bras.sql delimiter ";"
select "update faprdcad set cod_bras_tiss = ('"||cod_bras_tiss||"') where codigo = ('"||codigo||"')"
from faprdcad where tipo_prd = "MED" and cod_bras_tiss <> ""
--not exists (select * from faccicad t2 where t2.codigo="229287" and
--t2.cod_con = faplacad.cod_con and t2.cod_pla = faplacad.cod_pla)

unload to fapri.sql delimiter ";"
select "update fapricad set privilegio = ('"||privilegio||"') where cod_mod = ('"||cod_mod||"') and sistema = 'URG' and cod_grupo = 'REC2'"
from fapricad where sistema = "URG" and cod_grupo = "RECEP"


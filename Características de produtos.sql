select
"insert into escarprd values ('OPME','"||codigo||"');"
from faprdcad
where tipo_prd = "MEP" and bloqueado = "N"

select * from escarprd where cod_prd in (select codigo from faprdcad where tipo_prd = "MEP")
and cod_car = "OPME"

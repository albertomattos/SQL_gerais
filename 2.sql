select leito, cod_pac, data, hora
from falehcad
where leito not in (
select leito from faleicad)
and leito not in ('EXTER','URGEN','AMBUL')
--and a.leito like "405%"
order by leito


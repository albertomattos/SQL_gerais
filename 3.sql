select a.leito, a.cod_pac, a.data, a.hora,b.data_ent, b.hora_ent, b.data_alta, b.hora_alta
from falehcad a, fapaccad b
where a.cod_pac = b.cod_pac
and a.data between "01/03/2008" and "30/04/2008" and (a.leito like "L%" or a.leito = "CETIN")
order by a.data, a.hora

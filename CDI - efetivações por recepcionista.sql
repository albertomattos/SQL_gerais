select u.data_ent, v.apelido usuario, count(v.apelido) quant --u.data_ent data, to_char(u.hora_ent,'HH24:MI') hora, t.descricao
from fapaccad u, fausucad v, faalacad t
where u.cod_matricula = v.matricula and u.cod_ala = t.cod_ala
and u.data_ent between '01/01/2014' and '30/01/2014' and u.tipo_pac = 'E'
and u.cod_ala not in ('LABO','CMED', 'OFTA','DAYH', 'PSCG', 'PSOR','PSCM','PSGO','HMDN','PEDI','HMDA','FISI','UNID','PSPE','PSPQ','CHEC')
group by u.data_ent, v.apelido
order by u.data_ent, count(v.apelido) desc

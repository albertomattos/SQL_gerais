select t.cod_pac, t.hora_ent, t.num_guia, t.cod_con, v.fantasia, t.cod_ala, u.apelido
from fapaccad t, fausucad u, faconcad v where t.cod_matricula = u.matricula and t.cod_con = v.cod_con
and t.data_ent >= '01/10/2013' and t.cod_con not in ('001','002')
and t.cod_pac >= 'A%' and t.num_guia < '10000000'
order by 2 desc

select t.data_ent entrada, t.cod_pac registro, b.nome_pac paciente, u.nome usuario, a.fantasia convenio
from fapaccad t, fausucad u, faconcad a, faprtcad b
where t.cod_matricula = u.matricula and t.cod_con = a.cod_con and t.cod_prt = b.cod_prt
and t.data_ent between '01/11/2014' and '10/11/2014'
and t.tipo_pac = 'A'

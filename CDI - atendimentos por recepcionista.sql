select t.data_ent, to_char(t.hora_ent, 'HH24:MI') hora_ent, v.descricao, u.nome, u.setor, z.cod_prd, a.descricao, a.tipo_prd
from fapaccad t, fausucad u, faalacad v, immovcad x, immovprd z, faprdcad a
where t.cod_matricula = u.matricula and t.cod_ala = v.cod_ala and t.cod_pac = x.cod_pac
and x.comanda = z.comanda and x.tipo_comanda = z.tipo_comanda and z.cod_prd = a.codigo
and t.data_ent between '01/01/2014' and '10/01/2014'
and t.tipo_pac = 'E' and t.cod_ala not in ('LABO','CMED','FISI','OFTA')
and t.cod_sistema = 'DIA'

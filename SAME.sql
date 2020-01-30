select a.cod_prt, a.nome_pac, c.fantasia, b.cod_pac, b.data_ent, b.data_alta
from faprtcad a, fapaccad b, faconcad c, wpd.faprtcad@prodantigo d, wpd.fapaccad@prodantigo e, wpd.faconcad@prodantigo f
where a.cod_prt = b.cod_prt and a.cod_prt = d.cod_prt and d.cod_prt = e.cod_prt
and b.cod_con = c.cod_con and b.cod_con = f.cod_con
and b.tipo_pac = 'I'
and e.tipo_pac = 'I'
order by a.nome_pac

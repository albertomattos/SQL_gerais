select u.crm, u.nome_pro, w.tipo_pac
from famovprd t, faprocad u, famovcad v, fapaccad w
where t.cod_pro = u.cod_pro
and t.comanda = v.comanda and t.tipo_comanda = v.tipo_comanda
and v.cod_pac = w.cod_pac
and t.cod_pro <> '000001'
and w.tipo_pac = 'U'
and u.inativo = 'N' and u.cod_profissao = 'MEDC'
group by u.crm, u.nome_pro, w.tipo_pac
order by u.nome_pro

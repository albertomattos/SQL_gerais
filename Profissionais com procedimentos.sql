select u.crm, u.nome_pro, w.descricao, u.fone_celular, u.fone_res, u.email
from famovprd t, faprocad u, famovcad v, faespcad w, faesppro x
where t.cod_pro = u.cod_pro and u.cod_pro = x.cod_pro and w.cod_esp = x.cod_esp
and t.comanda = v.comanda and t.tipo_comanda = v.tipo_comanda
and t.cod_pro <> '000001' and x.sn_principal = 'S'
and u.inativo = 'N' and u.cod_profissao = 'MEDC'
and v.data_mov between '01/01/2017' and '18/01/2018'
group by u.crm, u.nome_pro, w.descricao, u.fone_celular, u.fone_res, u.email, u.cod_profissao
order by u.nome_pro

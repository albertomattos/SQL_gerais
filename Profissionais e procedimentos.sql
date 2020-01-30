select distinct u.crm, u.nome_pro, x.descricao, count(U.Nome_Pro)
from famovprd t, faprocad u, famovcad v, faprdcad w, faespcad x, faesppro y
where t.cod_pro = u.cod_pro
and t.comanda = v.comanda and t.tipo_comanda = v.tipo_comanda
and t.codigo = w.codigo and u.cod_pro = y.cod_pro and x.cod_esp = y.cod_esp
and t.cod_pro <> '000001'
and u.inativo = 'N' and u.cod_profissao = 'MEDC'
and v.data_mov between '01/01/2012' and '31/03/2012'
and w.tipo_prd in (select tipo_prd from fatipcad where pre_class = 'HON')
and w.tipo_prd <> 'CON' and w.codigo not in ('000007','216611','000020')
group by u.crm, u.nome_pro, x.descricao, w.codigo, w.descricao
order by u.nome_pro

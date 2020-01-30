select u.cod_pac, t.comanda, t.tipo_comanda, v.tipo_prd, t.codigo, v.descricao, t.cod_tabela, t.rowid
from famovprd t, famovcad u, faprdcad v
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda and t.codigo = v.codigo
and t.cod_tabela = '03'
and v.tipo_prd = 'DES'
and u.cod_pac = 'F236258'

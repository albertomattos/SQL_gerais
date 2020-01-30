select t.crm, t.nome_pro, t.email, v.descricao, t.cod_profissao, t.fone_celular, t.fone_res
from faprocad t, faesppro u, faespcad v where t.cod_pro = u.cod_pro and v.cod_esp = u.cod_esp
and u.sn_principal = 'S' and t.inativo = 'N' and t.cod_profissao = 'MEDC'
order by v.descricao, t.nome_pro


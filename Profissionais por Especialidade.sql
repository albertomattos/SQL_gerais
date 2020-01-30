select t.crm, t.nome_pro, u.descricao from faprocad t, faespcad u, faesppro v
where t.cod_pro = v.cod_pro and u.cod_esp = v.cod_esp
and t.inativo = 'N' and v.sn_principal = 'S' and t.cod_profissao = 'MEDC'
order by t.nome_pro

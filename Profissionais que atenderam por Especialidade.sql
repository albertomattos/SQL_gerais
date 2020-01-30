select t.cod_pro, t.crm, t.nome_pro, u.descricao from faprocad t, faespcad u, faesppro v
where t.cod_pro = v.cod_pro and u.cod_esp = v.cod_esp and t.inativo = 'N' and v.sn_principal = 'S' and t.cod_profissao = 'MEDC'
and t.cod_pro in (select cod_pro from famovprd a, famovcad b where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.data_mov between '01/01/2017' and '06/02/2018')
and u.descricao like 'CARD%'
order by t.nome_pro

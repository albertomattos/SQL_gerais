select c.descricao, count(c.descricao) from fapaccad a, faprocad b, faespcad c, faesppro d
where a.cod_pro = b.cod_pro and b.cod_pro = d.cod_pro and c.cod_esp = d.cod_esp
and a.data_ent between '01/01/2012' and '31/01/2012'
and a.tipo_pac = 'I'
and d.sn_principal = 'S'
group by c.descricao
order by c.descricao

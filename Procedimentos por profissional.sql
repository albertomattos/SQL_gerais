select count(b.nome_pro), b.nome_pro, d.descricao from faprccad a, faprocad b, faesppro c, faespcad d, fapaccad e
where a.cod_pro = b.cod_pro
and b.cod_pro = c.cod_pro
and c.cod_esp = d.cod_esp
and a.cod_pac = e.cod_pac
and prev_real = 'R'
and principal = 'S'
and data_real between '01/01/2012' and '31/01/2012'
and e.tipo_pac = 'I'
group by b.nome_pro, d.descricao
order by count(b.nome_pro) desc

select faprocad.crm, faprocad.uf_crm, faprocad.nome_pro, faespcad.descricao from faprocad, faesppro, faespcad
where faprocad.cod_pro = faesppro.cod_pro
and faesppro.cod_esp = faespcad.cod_esp
and faprocad.inativo = "N"
order by faprocad.nome_pro

--select nome_pro, crm, cpf, descricao
select *
from faprocad, faesppro, faespcad
where faprocad.cod_pro = faesppro.cod_pro
and faesppro.cod_esp = faespcad.cod_esp
and inativo = 'N'
and cod_profissao = 'MEDC'
and faesppro.sn_principal = 'S'
order by nome_pro

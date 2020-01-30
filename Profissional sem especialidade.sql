select crm,nome_pro from faprocad
where cod_pro not in (select cod_pro from faesppro)
and inativo = 'N' and cod_profissao = 'MEDC'
order by nome_pro


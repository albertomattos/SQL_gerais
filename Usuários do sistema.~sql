--Usuários por módulo:
select a.sistema, a.matricula, b.apelido, b.nome, b.setor, a.dt_hora_ult_acesso
from faususis a, fausucad b where a.matricula = b.matricula
and dt_hora_ult_acesso is not null
and ind_usuario_ativo = 'S'
and sistema = 'URG'
and dt_hora_ult_acesso <= '31/12/2016'
order by dt_hora_ult_acesso

select faususis.*, rowid from faususis where matricula in ('2621','2781','180395','2841','3161','3828','3476','12345','3191','12012011','3570','220283','3663','358','3866','3168','10251','3043','1512','3751','3411','3674','292305')

select distinct sistema from faususis

--Apaga os usuários ativos que não usam determinado sistema há xx dias.
delete from faususis where matricula in (select a.matricula
from faususis a, fausucad b where a.matricula = b.matricula
and dt_hora_ult_acesso is not null
and ind_usuario_ativo = 'S'
and sistema = 'VIS'
and dt_hora_ult_acesso <= '31/12/2016')
and sistema = 'VIS'
and dt_hora_ult_acesso <= '31/12/2016'

-- Usuários ativos sem sistema cadastrado
select * from fausucad where matricula not in (select matricula from faususis)
and ind_usuario_ativo = 'S' order by nome

-- Desativando usuários ativos sem sistema (sql anterior)
update fausucad set ind_usuario_ativo = 'N' where matricula not in (select matricula from faususis) and ind_usuario_ativo = 'S'

-- Quantidade de usuários ativos
select count(distinct apelido) from fausucad where ind_usuario_ativo = 'S'

--Usuários ativos com validade vencida
select * from fausucad where ind_usuario_ativo = 'S' and dh_validade <= '07/03/2017'

--Desativar usuários acima
update fausucad set ind_usuario_ativo = 'N' where ind_usuario_ativo = 'S' and dh_validade <= '28/02/2017'

-- Usuários ativos sem utilizar sistema
select fausucad.matricula from faususis, fausucad where faususis.matricula = fausucad.matricula
and dt_hora_ult_acesso is not null and ind_usuario_ativo = 'S'
and fausucad.matricula not in (select fausucad.matricula from faususis, fausucad where faususis.matricula = fausucad.matricula
    --and dt_hora_ult_acesso >= '01/03/2011'
) order by setor, apelido

-- Lista retirada do sql acima
update fausucad set ind_usuario_ativo = 'N' where matricula in ('1520','9990266','1859','1872','2143','9990557','405','33','992','831','634','444654','9990135','181010')

-- Lista usuários que não acessam mais os módulos
select * from faususis where dt_hora_ult_acesso is null and sistema <> 'MDV'

-- Apaga os usuários relacionados so sql acima
delete from faususis where dt_hora_ult_acesso is null and sistema <> 'MDV'

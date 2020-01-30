select faprocad.nome_pro, faprocad.crm, faespcad.descricao, faprocad.data_nascimento
from faprocad, faesppro, faespcad where faprocad.inativo = "N"
and (faprocad.cod_pro = faesppro.cod_pro) and (faesppro.cod_esp = faespcad.cod_esp)


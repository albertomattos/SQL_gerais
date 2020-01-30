select cod_pro, nome_pro, end, bairro_res, cep_res, cidade_res, estado_res, email
from faprocad where inativo = "N" and ind_perm_intern = "S"
order by nome_pro


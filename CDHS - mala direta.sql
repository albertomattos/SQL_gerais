select nome_pac, nascimento, end_res, end_numero, end_complemento, bai_res, cid_res, est_res, cep_res, fone_res, celular
from faprtcad where data_obito is null
and cod_prt in (select cod_prt from cdhs)
order by nome_pac

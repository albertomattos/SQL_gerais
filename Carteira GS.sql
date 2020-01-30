select cod_prt, nascimento, sexo, est_civil, nome_pac, cpf, cid_res, est_res, nome_mae, end_res, end_numero,
end_complemento, bai_res, cep_res, identidade, orgao_emissor_id
from faprtcad
where faprtcad.cod_prt in (select cod_prt from t2)
group by cod_prt, nascimento, sexo, est_civil, nome_pac, cpf, cid_res, est_res, nome_mae, end_res, end_numero,
end_complemento, bai_res, cep_res, identidade, orgao_emissor_id

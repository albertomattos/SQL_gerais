select nome_pac, nascimento, end_res, end_numero, end_complemento, bai_res, cid_res, est_res,
 cep_res, fone_res, celular from faprtcad
  where ((end_res is not null and end_res <> "") and (end_res <> "IGNORADO") 
  and (end_res <> "*") and data_obito is null) order by nome_pac

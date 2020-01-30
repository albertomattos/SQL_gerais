select cep,* from facepcad where cod_tipo_lograd is null and nome_log is not null

update facepcad set cod_tipo_lograd = "508" where tipo_log LIKE "2¦TRAVESSA"

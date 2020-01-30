select v.apelido usuario, u.tipo_pac tipo, t.cod_prt prontuario, u.data_ent data, to_char(u.hora_ent,'HH:MI') hora, t.nome_pac paciente,
t.nome_mae, t.est_civil, t.nascimento, t.sexo, t.identidade, t.cpf, t.uf_naturalidade uf_nasc, w.no_localidade cidade_nasc, t.fone_res,
t.celular, x.co_cep cep, t.end_res endereco, t.end_numero numero, t.end_complemento complemento, t.bai_res bairro, t.cid_res cidade,
t.est_res estado
from faprtcad t, fapaccad u, fausucad v, tb_localidade w, tb_cep x
where t.cod_prt = u.cod_prt and u.cod_matricula = v.matricula and t.fk_locali_nasc = w.pk_locali(+) and t.fk_cep_res = x.pk_cep
and u.data_ent = '30/09/2013' and u.tipo_pac = 'A'
order by v.apelido, t.nome_pac

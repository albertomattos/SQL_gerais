select faprtcad.nome_pac, faprtcad.identidade, faprtcad.cpf, faprtcad.nascimento,
fone_res, end_res, end_numero, bai_res, cid_res, cep_res, fapaccad.data_ent, fapaccad.hora_ent
from fapaccad, faprtcad
where fapaccad.cod_prt = faprtcad.cod_prt
and data_ent between '01/11/2009' and '31/12/2009'
order by fapaccad.data_ent, fapaccad.hora_ent

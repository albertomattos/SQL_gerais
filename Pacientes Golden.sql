select DISTINCT nome_pac, matricula, nascimento, end_res, end_numero, end_complemento, bai_res, cid_res, est_res, cep_res, fone_res, celular
from faprtcad, fapaccad
where faprtcad.cod_prt = fapaccad.cod_prt
and cod_con in ('001', '002', '004')
and data_ent between "01/03/2009" and "28/02/2010"
order by nome_pac

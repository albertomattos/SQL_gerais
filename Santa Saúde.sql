--select fapaccad.cod_pac, faprtcad.nome_pac, data_ent, num_atestado_nasc, condicoes_rn, dura_gestacao, tipo_gravidez, tipo_parto
select faprtcad.nome_pac, data_ent, fapaccom.num_atestado_nasc, dura_gestacao, tipo_parto
from fapaccad, fapaccom, faprtcad
where fapaccad.cod_pac = fapaccom.cod_pac
and fapaccad.cod_prt = faprtcad.cod_prt
and fapaccad.cod_con = "108"
and cod_mae is not null
and data_ent between "01/04/2008" and "23/07/2008"
order by data_ent

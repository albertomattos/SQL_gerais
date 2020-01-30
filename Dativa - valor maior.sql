select fafatcad.fatura, fafatcad.valor_tot, fapaccad.cod_pac, faprtcad.nome_pac, fapaccad.matricula, fapaccad.senha, fapaccad.num_guia,
fafatcad.remessa, faremcad.data_entre
from faprtcad, fapaccad, fafatcad, faremcad
where faprtcad.cod_prt = fapaccad.cod_prt
and fafatcad.cod_pac = fapaccad.cod_pac
and faremcad.remessa = fafatcad.remessa
and fapaccad.cod_con = "056"
and faremcad.remessa = "041886"
order by fafatcad.valor_tot

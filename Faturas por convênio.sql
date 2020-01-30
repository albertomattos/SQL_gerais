select fapaccad.cod_pac, faprtcad.nome_pac, fapaccad.matricula, fapaccad.senha, fapaccad.num_guia,
fafatcad.fatura, fafatcad.remessa, faremcad.data_entre, fafatcad.valor_tot
from faprtcad, fapaccad, fafatcad, faremcad
where faprtcad.cod_prt = fapaccad.cod_prt
and fafatcad.cod_pac = fapaccad.cod_pac
and faremcad.remessa = fafatcad.remessa
and fapaccad.cod_con = "001"
and fafatcad.data_emiss between "02/01/2007" and "02/01/2007"
order by faprtcad.nome_pac

select fapaccad.cod_pac, faprtcad.nome_pac, fapaccad.matricula, fapaccad.senha, fapaccad.num_guia,
fafatcad.fatura, fafatcad.remessa, faremcad.data_emiss, faremcad.data_venci, faremcad.data_entre,
faremcad.nota_fis, fafatcad.valor_tot
from faprtcad, fapaccad, fafatcad, faremcad
where faprtcad.cod_prt = fapaccad.cod_prt
and fafatcad.cod_pac = fapaccad.cod_pac
and faremcad.remessa = fafatcad.remessa
and fapaccad.cod_con = "086"
and faremcad.remessa in ('046279','046413','046458','046491')
order by faremcad.remessa,faprtcad.nome_pac

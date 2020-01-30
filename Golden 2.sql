select fapaccad.cod_pac, fapaccad.cod_con, fapaccad.senha, fapaccad.num_guia, fapaccad.matricula, fafatcad.fatura
 from fapaccad, fafatcad
 where fapaccad.cod_pac = fafatcad.cod_pac
 and fafatcad.remessa = "033494"

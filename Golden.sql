-- select * from goremcad where cod_rem = "9762"
-- select * from faremcad where remessa = "032285"
-- select * from fafatcad where remessa = "032144"
 select fapaccad.cod_pac, fapaccad.cod_con, fapaccad.senha, fapaccad.num_guia, fapaccad.matricula, fafatcad.fatura, fafatcad.valor_tot Total
 from fapaccad, fafatcad
 where fapaccad.cod_pac = fafatcad.cod_pac
 and fafatcad.remessa = "033494"

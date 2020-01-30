select * from famovprd, faprocad, fafatcad, famovdestino where famovprd.cod_pro = faprocad.cod_pro
and famovprd.sequencial = famovdestino.sequencial
and famovdestino.cod_fatura = fafatcad.fatura
and faprocad.grupo = "694"
and fafatcad.remessa in (
	select remessa from faremcad where data_emiss between "01/09/2008" and "30/09/2008")


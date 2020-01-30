select cod_amb,fatura,* from faprdcad, fafatprd where faprdcad.codigo = fafatprd.cod_prd
and	fatura in
    	(select fatura from fafatcad where remessa = "052267")
and cod_amb like "%100%"

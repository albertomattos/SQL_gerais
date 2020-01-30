select fatura, cod_ala, fafatcad.cod_pac, fafatcad.cod_con, data_emiss, valor_tot, fafatcad.observacao
from fafatcad, fapaccad where fafatcad.cod_pac = fapaccad.cod_pac
and fafatcad.observacao like "%PAR%" and data_emiss between "01/12/2008" and "31/12/2008"
and fafatcad.cod_con in ("001","004")
order by fapaccad.cod_ala


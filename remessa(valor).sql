select sum(valor_ch+valor_filme+valor_mat_tax) from fapaccad,fafatcad
where fafatcad.cod_pac=fapaccad.cod_pac
and fafatcad.cod_con = '007'
and fafatcad.data_emiss between '01/01/2012' and '30/06/2013'
--and fafatcad.remessa="033219"

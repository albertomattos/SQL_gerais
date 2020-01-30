select distinct
(select count(*) from fafatcad a, fapaccad b where a.cod_pac = b.cod_pac
and a.data_emiss between '01/10/2015' and '31/10/2015'
and b.tipo_pac <> 'I'
and to_char(a.data_emiss,'MM') = to_char(b.data_alta,'MM')
and to_char(a.data_emiss,'YYYY') = to_char(b.data_alta,'YYYY'))/(select count(*) from fafatcad a, fapaccad b
where a.cod_pac = b.cod_pac
and a.data_emiss between '01/10/2015' and '31/10/2015'
and b.tipo_pac <> 'I')*100
from fafatcad a, fapaccad b where a.cod_pac = b.cod_pac
and a.data_emiss between '01/10/2015' and '31/10/2015'
and b.tipo_pac <> 'I'

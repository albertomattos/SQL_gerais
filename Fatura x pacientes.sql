--select n.fatura, n.cod_pac, n.data_emiss, n.valor_tot
select count (*)
from fafatcad n, fapaccad p where n.cod_pac = p.cod_pac and p.tipo_pac = "U"
--and n.destino = "P"
and n.data_emiss between "02/09/2003" and "01/03/2004"
-- and n.fatura_fechada = "N"

--select * from fafatcad --where tipo_pac = "U" and data_ent between "01/09/2003" and "29/02/2004"
--select count(*) from fapaccad where tipo_pac = "U" and data_ent between "01/09/2003" and "29/02/2004"


select faconcad.fantasia, SUM(fafatcad.valor_tot) total, faconcad.endereco, faconcad.bairro, faconcad.cidade, faconcad.estado, faconcad.contato
from fafatcad, faconcad
where faconcad.cod_con = fafatcad.cod_con
and fafatcad.data_emiss between "01/03/2006" and "31/03/2006"
and fafatcad.destino = "C"
group by faconcad.fantasia, faconcad.endereco, faconcad.bairro, faconcad.cidade, faconcad.estado, faconcad.contato
order by total desc


select faconcad.fantasia, SUM(fafatcad.valor_tot) total, faconcad.endereco, faconcad.bairro, faconcad.cidade, faconcad.estado, faconcad.contato, faconcad.telefone
from fafatcad, faconcad
where faconcad.cod_con = fafatcad.cod_con
and fafatcad.data_emiss between "01/08/2007" and "31/08/2007"
and fafatcad.destino = "C"
group by faconcad.fantasia, faconcad.endereco, faconcad.bairro, faconcad.cidade,
faconcad.estado, faconcad.contato, faconcad.telefone
order by total desc


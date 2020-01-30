select n.fatura, n.destino, n.cod_pac, n.cod_con, n.data_emiss, n.valor_tot
from fafatcad n, fapaccad p where n.cod_pac = p.cod_pac and p.tipo_pac = "I"
and n.destino = "P" and data_emiss > "04/01/2004" and n.fatura_fechada = "N"
--select * from fapaccad where tipo_pac = "I"
--select * from fafatcad

select * from fanotavl where nota_fiscal = "00002691"

select * from nota_fatura where nota_fiscal = "00002691"

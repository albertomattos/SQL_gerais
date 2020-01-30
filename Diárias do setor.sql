--Diárias consumidas
select sum(d.quant)
from famovcad c, famovprd d, faprdcad f where
c.comanda = d.comanda and c.tipo_comanda = d.tipo_comanda
and d.codigo = f.codigo
and c.data_mov between '01/07/2016' and '31/07/2016'
and c.set_ori = '0125'
and f.tipo_prd = 'DIA'

--Diárias faturadas
select sum(quant) from fafatprd where cod_set = '0133' and fatura in (select fatura from fafatcad where data_emiss
between '01/07/2016' and '31/07/2016')
and cod_prd in (select codigo from faprdcad where tipo_prd = 'DIA')

select * from fasetcad

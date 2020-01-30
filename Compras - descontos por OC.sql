select round(sum((b.quant*b.valor)),2) valor,
round(sum(b.valor_tot),2) total,
round(sum(a.frete),2) frete
from esmovcad a, esmovite b, faprdcad c, fatipcad d where a.documento = b.documento and a.tipo_documento = b.tipo_documento
and b.cod_prd = c.codigo and c.tipo_prd = d.tipo_prd
and a.tipo_documento = 'PED' and d.natureza is null
--and d.tipo_prd = 'OPM'
and a.data_mov between '01/11/2012' and '30/11/2012'

select * from esmovcad where frete > 0 and tipo_documento = 'PED'
and data_mov between '01/11/2012' and '30/11/2012'

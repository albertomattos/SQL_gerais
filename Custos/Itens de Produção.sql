select rel.*, pepr.DESCRICAO
from CCU_PPUP rel, CCU_PEPR pepr
where (rel.COD_PPR = pepr.COD_PPR)
order by 2,4
--and (rel.COD_UNP = '021')

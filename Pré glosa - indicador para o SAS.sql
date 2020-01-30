select sum(valor_tot), sum(valor_guia), sum(valor_tot) - sum(valor_guia), (sum(valor_tot) - sum(valor_guia))/sum(valor_tot)*100
from faremcad
where data_entre >= '01/03/2016'
and data_entre <= '31/03/2016'
--and cod_con = '073'
and recurso_glosa is null
--group by cod_con
--select * from faremcad where data_entre >= '01/03/2016' and data_entre <= '31/03/2016'

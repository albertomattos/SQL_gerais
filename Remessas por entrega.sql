select c.fantasia, r.remessa, r.data_emiss, r.data_entre, r.valor_tot
from faremcad r, faconcad c where r.data_emiss between "01/08/2005" and "31/08/2005"
and r.cod_con = c.cod_con and cod_uni = "DAHER" and recurso_glosa is NULL order by c.fantasia


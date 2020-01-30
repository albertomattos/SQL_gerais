select a.codigo, a.descricao, d.cod_mat_coleta, d.descricao, b.descricao, b.cod_com
from faprdcad a, lbcomcad b, lbexacom c, lbmatcad d, lbmatcom e
where a.codigo = c.cod_prd
and c.cod_com = b.cod_com
and b.cod_com = e.cod_com(+)
and d.cod_mat_coleta(+) = e.cod_mat_coleta
and a.tipo_prd in ('LAB','EXA','MEN')
and a.data_cad >= '05/11/2012'
order by 1
--and a.codigo = '215973'

--select * from lbmatcad

--select count(*) from faprdcad where tipo_prd in ('LAB','EXA','MEN')

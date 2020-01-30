select a.codigo, a.descricao, a.tipo_prd, b.descricao, a.gru_est, d.descricao, lin_mat, c.descricao, e.cod_set, e.est_atu, a.dat_ultcon
from faprdcad a, fatipcad b, eslincad c, esgrecad d, esestcad e
where a.tipo_prd = b.tipo_prd
and a.lin_mat = c.cod_lin
and a.gru_est = d.cod_gre
and a.codigo = e.cod_prd
and b.tem_estoque = 'S'
and a.bloqueado = 'N'
order by a.tipo_prd, a.gru_est, a.lin_mat, a.codigo

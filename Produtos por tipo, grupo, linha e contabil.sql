select t.codigo, t.descricao, t.tipo_prd, u.descricao, t.gru_est, v.descricao, t.lin_mat, w.descricao, t.cod_gcn, x.descricao
from faprdcad t, fatipcad u, esgrecad v, eslincad w, esgcncad x
where t.tipo_prd = u.tipo_prd and t.gru_est = v.cod_gre (+) and t.lin_mat = w.cod_lin (+) and t.cod_gcn = x.cod_gcn (+)
and t.tipo_prd in (select tipo_prd from fatipcad where pre_class = 'MAT')
order by t.tipo_prd

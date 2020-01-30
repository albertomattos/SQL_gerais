select codigo, a.descricao, d.descricao, c.descricao, b.descricao from faprdcad a, eslincad b, esgrecad c, fatipcad d
where a.lin_mat = b.cod_lin and a.gru_est = c.cod_gre and a.tipo_prd = d.tipo_prd
and a.tipo_prd in ('STI','ETI') and bloqueado = 'N' order by a.tipo_prd, c.descricao, b.descricao, a.descricao

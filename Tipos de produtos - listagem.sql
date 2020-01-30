select codigo, faprdcad.descricao, eslincad.descricao, esgrecad.descricao from faprdcad, outer(eslincad, esgrecad)
where faprdcad.lin_mat = eslincad.cod_lin
and faprdcad.gru_est = esgrecad.cod_gre
and tipo_prd = "MAL" and bloqueado = "N"
order by faprdcad.descricao

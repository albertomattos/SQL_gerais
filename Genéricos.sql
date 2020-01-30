select codigo, descricao, uni_compra, custo_atu from faprdcad where tipo_prd = "MED" and lin_mat = "GEN"
and bloqueado = "N"
order by descricao

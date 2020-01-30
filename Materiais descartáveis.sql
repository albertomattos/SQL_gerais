select t.codigo, t.descricao, t.uni_compra compra, t.uni_distri consumo, t.uni_estoqu estoque, t.divisor,
t.divisor_simpro, t.fator, t.cod_fabric_padrao, t.estoq_dist, t.tipo_cons, t.cod_bras brasindice, t.cod_bras_tiss bras_tiss,
t.cod_simpro, t.rowid from faprdcad t where tipo_prd = 'FIO' and bloqueado = 'N'
order by t.descricao

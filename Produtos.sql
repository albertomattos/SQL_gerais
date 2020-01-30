select t.codigo, t.descricao descricao_35_digitos, t.descricao_comp descricao_completa_60_digitos, t.tipo_prd, u.descricao tipo_de_produto,
u.faturavel, z.descricao grupo_estoque, a.descricao linha, t.uni_compra, t.uni_estoqu, t.uni_distri uni_consumo, t.fator,
t.divisor div_compra_consumo, t.estoq_dist estoque_consumo, t.tipo_cons, t.cod_bras brasindice, t.cod_bras_tiss, t.cod_simpro,
t.divisor_simpro, t.ped_min, t.est_min, t.ponto_ressupr, t.estoque_minimo, t.ind_antimicrobiano antimicrobiano, v.descricao apresentacao,
t.prod_nao_padr nao_padrao, t.sn_alto_risco alto_risco, w.nome fabricante, y.descricao sal
from faprdcad t, fatipcad u, apresentacao v, esfabricante w, essalprd x, essalcad y, esgrecad z, eslincad a
where t.tipo_prd = u.tipo_prd
and t.cod_fabric_padrao = w.cod_fabricante (+)
and t.cod_apresent = v.cod_apresent (+)
and t.codigo = x.cod_prd (+)
and x.cod_sal = y.cod_sal (+)
and t.gru_est = z.cod_gre (+)
and t.lin_mat = a.cod_lin (+)
and u.tem_estoque = 'S'
order by t.tipo_prd, z.descricao, a.descricao, t.descricao

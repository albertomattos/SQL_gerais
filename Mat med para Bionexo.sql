select t.descricao, t.codigo, u.nome, t.uni_compra, t.preco_fabrica, v.descricao
from faprdcad t, esfabricante u, fatipcad v
where (u.COD_FABRICANTE (+) = t.COD_FABRIC_PADRAO)
and t.tipo_prd = v.tipo_prd
and v.pre_class = 'MAT'
order by v.descricao

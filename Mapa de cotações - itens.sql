select escotite.cod_prd, faprdcad.descricao, escotite.cod_for, escotite.preco_pra, escotite.quant, espagcad.descricao
from escotite, escotcad, espagcad, faprdcad
where escotite.cod_cot = escotcad.cod_cot
and escotite.cod_for = escotcad.cod_for
and escotcad.cod_pag = espagcad.cod_pag
and faprdcad.codigo = escotite.cod_prd
and escotcad.cod_cot = '015365'
--and preco_pra <> '0'
--and escotite.cod_prd = "083121"
order by cod_prd

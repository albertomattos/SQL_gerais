select a.tipo_prd, b.descricao, a.codigo, a.descricao, a.descricao_comp, a.ult_compra, a.dat_ultmov
from faprdcad a, fatipcad b
where a.tipo_prd = b.tipo_prd
and a.bloqueado = 'N'
and b.pre_class = 'MAT'
order by a.tipo_prd

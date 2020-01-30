--select * from faprecad where tabela = 02
--select * from faprdcad where tipo_prd = "DES" or tipo_prd = "FIO"

select faprdcad.codigo, faprdcad.descricao, faprdcad.tipo_prd, faprecad.tabela, faprecad.valor
from faprdcad, faprecad
where faprdcad.codigo = faprecad.codigo
and (faprecad.tabela = "01" or faprecad.tabela = "02")
--and faprecad.valor
-- and faprecad.valor is not null)
--and (faprecad.tabela = "02" and faprecad.valor is null)
and (faprdcad.tipo_prd = "DES" or faprdcad.tipo_prd = "FIO")
order by descricao


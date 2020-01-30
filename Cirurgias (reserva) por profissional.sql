--select * from faprocad
--select * from rcrsvcad
--select * from rccirrsv
--select * from faprdcad
select rcrsvcad.data_inicial, rcrsvcad.nome_pac, faprdcad.descricao, faprocad.nome_pro
from rcrsvcad, faprocad, faprdcad, rccirrsv
where rcrsvcad.cod_rsv = rccirrsv.cod_rsv and faprocad.cod_pro = rcrsvcad.cod_pro and faprdcad.codigo = rccirrsv.cod_prd
and faprocad.cod_pro = "009338" and rcrsvcad.data_inicial > "01/02/2005"
order by rcrsvcad.data_inicial


--select fafilhon.tabela, fafilhon.val_filme filme, fafilhon.val_honor CH, faccgcad.cod_con, faccgcad.cod_pla,
--faccgcad.tab_int tabela, faconcad.fantasia convenio
--from fafilhon, faccgcad, faconcad
--where faccgcad.cod_con = faconcad.cod_con
--and fafilhon.validade = "01/07/2004" and fafilhon.tipo_prd = "EXA"

select * from fafilhon where tipo_prd = 'PRO' and validade = "01/07/2004" order by tabela
select * from faccgcad where tipo_prd = "EXA" order by tab_int

select faccgcad.cod_pla, faccgcad.tab_int, faconcad.fantasia convenio
from faccgcad, faconcad where tipo_prd = "EXA" and faccgcad.cod_con = faconcad.cod_con
order by faccgcad.tab_int

--select * from fatipcad
--select cod_con, fantasia from faconcad


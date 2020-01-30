select t.tipo_prd, t.codigo, t.descricao, t.ped_min, t.est_min, t.estoque_minimo, t.classificacao, t.ponto_ressupr
from faprdcad t where t.bloqueado = 'N' and t.tipo_prd in (select a.tipo_prd from fatipcad a where a.pre_class = 'MAT' and a.faturavel ='S')
order by 1,3

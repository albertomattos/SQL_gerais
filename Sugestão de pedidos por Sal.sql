select t.codigo, a.descricao sal, t.descricao, u.descricao dosimetria, v.descricao apresentacao, t.uni_distri, t.uni_compra, t.custo_atu
from faprdcad t, disp_categoria u, apresentacao v, essalcad a, essalprd b
where t.cod_categ = u.cod_categ
and t.cod_apresent = v.cod_apresent
and b.cod_prd = t.codigo
and a.cod_sal = b.cod_sal
and tipo_prd = 'MED' and gru_est = 'ANVI'
order by u.descricao, t.cod_apresent

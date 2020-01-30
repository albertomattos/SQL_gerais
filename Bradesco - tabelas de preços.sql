select u.cod_cbhpm, t.tabela, t.codigo, t.valor
from faprecad t, faprdcad u, faapetab v
where t.codigo = u.codigo and t.tabela = v.tabela and u.tipo_prd = v.tipo_prd
and u.tipo_prd in ('PRO') and t.validade = '02/12/2015'
and u.bloqueado = 'N'
order by t.tabela, u.cod_cbhpm

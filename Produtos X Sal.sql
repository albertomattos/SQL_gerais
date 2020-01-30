select t.codigo, t.descricao, u.descricao from faprdcad t, essalcad u, essalprd v
where t.codigo = v.cod_prd
and v.cod_sal = u.cod_sal
order by t.descricao

select t.codigo, t.descricao, t.cod_apresent, u.cod_sal, u.descricao from faprdcad t, essalcad u, essalprd v
where t.codigo = v.cod_prd and u.cod_sal = v.cod_sal
and t.bloqueado = 'N' and t.tipo_prd in ('MED','MQU')
order by u.descricao, t.descricao
----Med sem sal associado:
select t.codigo, t.descricao, t.cod_apresent from faprdcad t
where t.bloqueado = 'N' and t.tipo_prd in ('MED','MQU')
and t.codigo not in (select cod_prd from essalprd)
order by t.descricao

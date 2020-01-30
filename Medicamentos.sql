--select * from escarprd
--select * from escarcad
select faprdcad.descricao from faprdcad, escarcad, escarprd where escarprd.cod_prd = faprdcad.codigo
and faprdcad.tipo_prd = "MED" and faprdcad.bloqueado = "N"
and escarprd.cod_car = "0004"
group by faprdcad.descricao
order by faprdcad.descricao


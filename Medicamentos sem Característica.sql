select codigo, descricao from faprdcad where tipo_prd = 'MED' and codigo not in (select cod_prd from escarprd)
order by descricao

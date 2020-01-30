select codigo, descricao, cod_bras, cod_bras_tiss from faprdcad where tipo_prd = 'MED' and codigo not in (select codigo from faprecad)
order by descricao

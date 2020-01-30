update escarprd set verifica_subst = 'S' where cod_prd in (select codigo from faprdcad where tipo_prd = 'MED')

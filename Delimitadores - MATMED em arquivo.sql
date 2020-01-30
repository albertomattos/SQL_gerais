unload to medica.txt delimiter ";"
select descricao, uni_distri, valor from faprecad, faprdcad where faprecad.codigo = faprdcad.codigo
and faprdcad.tipo_prd = "DES"
and validade = (select max(validade) from faprecad, faprdcad where faprecad.codigo = faprdcad.codigo
and tabela = "01"
and tipo_prd = "DES")


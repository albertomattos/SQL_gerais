select t.tipo_prd, t.codigo, t.descricao, t.tipo_cons, t.rowid from faprdcad t
where tipo_prd in (select tipo_prd from fatipcad where pre_class = 'MAT')
and tipo_cons = '1'

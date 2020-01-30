select codigo, descricao from faprdcad where tipo_prd = 'MED' and bloqueado = 'N' and codigo not in (select cod_prd from eslote_validade)
select * from faprdcad where tipo_prd = 'DES' and bloqueado = 'N' and codigo in (select cod_prd from eslote_validade where cod_barra_fab is null)
select codigo, descricao from faprdcad where tipo_prd = 'DES' and bloqueado = 'N' and codigo not in (select cod_produto from codigo_barras)

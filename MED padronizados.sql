select t.codigo, t.descricao, u.descricao, t.rowid from faprdcad t, apresentacao u where t.cod_apresent = u.cod_apresent
and tipo_prd = 'MED' and prod_nao_padr = 'N'

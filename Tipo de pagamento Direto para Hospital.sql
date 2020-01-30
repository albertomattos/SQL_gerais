update famovprd set tipo_pgto = "H"
where famovprd.codigo in
    (select faprdcad.codigo from faprdcad
     where (faprdcad.tipo_prd = "DES" or faprdcad.tipo_prd = "MED"))
and tipo_pgto = "D"

select * from faecpcad
select * from faequcad where cod_con = "032" order by cod_equ
select cod_bras_tiss[3,10], descricao from faprdcad where tipo_prd = "MED"

unload to equ.txt
select cod_bras_tiss[3,10],descricao from faprdcad
where tipo_prd = "MED"
and cod_bras_tiss <> "" order by cod_bras_tiss

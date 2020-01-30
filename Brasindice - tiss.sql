select codigo, descricao, cod_bras, cod_bras_tiss from faprdcad where tipo_prd = "MED" and bloqueado = "N"
and cod_bras_tiss = "" order by descricao

select cod_bras, cod_bras_tiss from faprdcad where tipo_prd = "MED" order by cod_bras_tiss desc*/

select descricao, cod_bras, cod_bras_tiss from faprdcad where codigo = "206050"

/*Verificar códigos Brasindice Tiss*/
select cod_bras_tiss,* from faprdcad where cod_bras_tiss is not null and cod_bras_tiss <> "" order by cod_bras_tiss desc

select descricao, tipo_prd, cod_bras, cod_bras_tiss from faprdcad
where cod_bras_tiss is not null and cod_bras_tiss <> "" order by cod_bras_tiss

/*Atualizar código Brasíndice Tiss*/
update faprdcad set cod_bras_tiss = "72150011" where codigo = "039070"

select cod_bras, cod_bras_tiss from faprdcad where tipo_prd = "MED" and bloqueado = "N"
and cod_bras_tiss = ""

select
"insert into faprdcad values ('OPME','"||codigo||"');"
from faprdcad
where tipo_prd = "MED" and bloqueado = "N"
and cod_bras_tiss = ""

select descricao, cod_bras, cod_bras_tiss, codigo from faprdcad where codigo in
('009236','011748','038807','243690','256822','258650','258682','268107','268565','322352','326880','358711','387468','387468','395497','532388','615291','708450')
and cod_bras_tiss = ""



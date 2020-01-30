select

"SELECT cod_guia,'"||trim(tabname)||"',"||
"count(*) FROM "||trim(tabname)||" where cod_guia = '392035' GROUP BY 1,2 ORDER BY 1,2"
from systables, syscolumns
where
systables.tabid=syscolumns.tabid
and
colname="cod_guia"

select
"update faprecad set coef_honor = '"||coef_honor||"' where tabela = '81' and validade = '26/02/2009' and codigo = (select codigo from faprdcad where cod_amb = '"||amb||"'and tipo_prd = 'HON' and mnemonico like 'BRADESCO%'))"
from brad where amb <> "1"

update faprecad set coef_honor = '1051.4900000000000000' where tabela = '80' and codigo =
(select codigo from faprdcad where cod_amb = '32120141' and tipo_prd in ("ANE","HEM","CON","HMD","CAR","HON"))


where validade =
(select max(validade) from faprecad where tabela = "19" and codigo in
    (select codigo from faprdcad where tipo_prd = "HON"))
and codigo in
(select codigo from faprdcad where tipo_prd = "HON")
and tabela = "28"

select * from brad

select
"insert into escarprd values ('OPME','"||codigo||"');"
from faprdcad
where tipo_prd = "ESP" and bloqueado = "N"


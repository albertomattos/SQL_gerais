--select * from faccgcad where tipo_prd = "DIA" order by cod_con, cod_pla
--select * from faconcad where ind_inativo = "0" order by cod_con
/*select faccgcad.cod_con, faconcad.fantasia, faccgcad.cod_pla, faccgcad.tipo_prd, faccgcad.tab_int,
faccgcad.tab_amb, faccgcad.tab_urg from faconcad, faccgcad
where faccgcad.cod_con = faconcad.cod_con
and faccgcad.tipo_prd = 'TAX'
and faccgcad.cod_con = '066'
order by faccgcad.tipo_prd, faccgcad.cod_con, faccgcad.cod_pla*/

select c.descricao, b.descricao, b.cod_amb, d.tabela, d.descricao, a.valor from faprecad a, faprdcad b, fatipcad c, faapetab d
where a.codigo = b.codigo and b.tipo_prd = c.tipo_prd and a.tabela = d.tabela and b.tipo_prd = d.tipo_prd
and a.validade = '01/02/2016'
and b.tipo_prd in ('TOM')
--and c.faturavel = 'S'
order by b.tipo_prd, a.tabela, b.descricao

/*
 (select max(validade) from faprecad where tabela IN ('08','15','21','38') and codigo in
    (select codigo from faprdcad where tipo_prd in
            (select tipo_prd from fatipcad where faturavel = 'S')
     )) order by b.tipo_prd, a.tabela, b.descricao
     
and a.codigo in
(select codigo from faprdcad where tipo_prd = 'GMD')
and tabela in ('08','15','21','38') order by B.DESCRICAO
/*
select codigo, descricao from faprdcad where tipo_prd = 'GMD' order by 2

update faprecad set coef_honor = "1729.37" where codigo = "189437" and validade = "01/08/2008" and tabela = "28"

select
"update faprecad set coef_honor =  ('"||coef_honor||"');"
from faprecad
where validade =
(select max(validade) from faprecad where tabela = "19" and codigo in
    (select codigo from faprdcad where tipo_prd = "HON"))
and codigo in
(select codigo from faprdcad where tipo_prd = "HON")
and tabela = "28"

select * from bradesco
*/

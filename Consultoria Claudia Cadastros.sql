select c.tipo_prd, a.codigo, c.descricao, a.valor, b.tabela, b.descricao, c.co_tuss
from faprecad a, faapetab b, faprdcad c
where a.tabela = b.tabela and a.codigo = c.codigo and b.tipo_prd = c.tipo_prd
and b.tipo_prd in ('GMD', 'DIA', 'TAX', 'VID') and a.validade = '25/07/2017'
and c.tipo_prd in ('GMD', 'DIA', 'TAX', 'VID')
order by 1,3

SELECT t.tipo_prd, u.descricao, t.tabela, t.ind_cbhpm, t.val_filme, t.valor_uco FROM FAFILHON t, faapetab u WHERE t.tabela = u.tabela
and t.tipo_prd = u.tipo_prd AND u.tipo_prd in ('LAB','END','EXA','RAD','RAT','REM','TOM','USG')
AND VALIDADE = '01/10/2016'

select * from fatipcad where tipo_prd in ('LAB','END','EXA','RAD','RAT','REM','TOM','USG')

SELECT COD_PORTE, DESCRICAO FROM PORTE_PROCEDIMENTO ORDER BY COD_PORTE

SELECT GER.PK_PREPGER,GER.COD_UNI,GER.TIPO_PRD,GER.VALIDADE,GER.FK_APETAB,GER.COD_PORTE,GER.VALOR,TAB.TABELA
FROM PRECO_PORTE_GER GER, FAAPETAB TAB WHERE GER.FK_APETAB = TAB.PK_APETAB AND GER.COD_UNI = '0001' AND TAB.TIPO_PRD = 'PRO'
AND GER.VALIDADE = '15/09/2016'  AND TAB.TABELA = '01'

select c.tipo_prd, a.codigo, c.cod_simpro, c.co_tuss, c.co_tuss_simpro, c.descricao, c.uni_distri, a.valor, b.tabela, b.descricao
from faprecad a, faapetab b, faprdcad c
where a.tabela = b.tabela and a.codigo = c.codigo and b.tipo_prd = c.tipo_prd
and b.tipo_prd in ('DES','FIO') and a.validade = '05/09/2016'
and c.tipo_prd in ('DES','FIO') and c.bloqueado = 'N'
order by 2,3,5

select c.tipo_prd, a.codigo, c.cod_bras, c.co_tuss, c.co_tuss_bras, c.descricao, c.uni_distri, a.valor, b.tabela, b.descricao
from faprecad a, faapetab b, faprdcad c
where a.tabela = b.tabela and a.codigo = c.codigo and b.tipo_prd = c.tipo_prd
and b.tipo_prd in ('MED') and a.validade = '05/09/2016'
and c.tipo_prd in ('MED') and c.bloqueado = 'N'
order by 6,9

select c.tipo_prd, a.codigo, c.cod_simpro, c.co_tuss, c.co_tuss_simpro, c.descricao, c.uni_distri, a.valor
from faprecad a, faapetab b, faprdcad c
where a.tabela = b.tabela and a.codigo = c.codigo and b.tipo_prd = c.tipo_prd
and b.tipo_prd in ('OPM') and a.validade = '01/08/2011'
and c.tipo_prd in ('OPM') and c.bloqueado = 'N'
order by 6

select l.codigo, l.descricao, j.descricao from essalcad j, essalprd k, faprdcad l where j.cod_sal = k.cod_sal and k.cod_prd = l.codigo
and l.tipo_prd = 'MED' and l.bloqueado = 'N' order by 3
